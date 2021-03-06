class ScalingService

  def initialize queue:, num_instances:
    @queue          = queue
    @num_instances  = num_instances
  end

  def scale_workers
    response = $ec2.run_instances({
      image_id:           AWS_CONFIG["image_id"],
      min_count:          1,
      max_count:          @num_instances,
      key_name:           AWS_CONFIG["key_name"],
      instance_type:      AWS_CONFIG["instance_type"],
      network_interfaces: [ { subnet_id: AWS_CONFIG["subnet_id"], device_index: 0, associate_public_ip_address: true, groups: [ AWS_CONFIG["security_group"] ] } ]
    })

    Rails.logger.info "Launched #{response.instances.length} worker instances"

    @worker_instances = response.instances.map(&:instance_id)
    $ec2.create_tags({ resources: @worker_instances, tags: [{ key: "Name", value: "Trends Worker" }] })

    response.instances.each_with_index do |instance, index|
      wait_count = 0
      until instance_running?(instance.instance_id) || wait_count >= 12 do
        wait_count += 1
        Rails.logger.info "Waiting for #{instance.instance_id} to start. Current status: #{instance_state(instance.instance_id)}"

        # Allow instance time to start up properly
        sleep(10)
      end

      begin
        raise "Instance #{instance.instance_id} never started properly." unless instance_running?(instance.instance_id)

        Rails.logger.info "Deploying worker code on #{instance.instance_id} (#{index+1}/#{response.instances.length})"
        jenkins_params  = { host: hostname(instance.instance_id), queue: @queue }
        jenkins_opts    = { "build_start_timeout" => 60, "cancel_on_build_start_timeout" => true  }
        build_num       = $jenkins_client.job.build( JENKINS_CONFIG["job"], jenkins_params, jenkins_opts )

        while ( (job_response = $jenkins_client.job.get_build_details(JENKINS_CONFIG["job"], build_num))["result"].nil? ) do
          Rails.logger.info "Waiting for deployment to complete on #{instance.instance_id}"
          sleep(5)
        end

        raise "Jenkins deploy failed for #{job_response["fullDisplayName"]}" unless job_response["result"] == "SUCCESS"
      rescue => e
        Rails.logger.error "Unable to deploy worker code to #{instance.instance_id}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n\t")
        $ec2.terminate_instances({ instance_ids: [instance.instance_id] })
        @worker_instances.delete(instance.instance_id)
      end
    end
  end

  def retire_workers
    return unless @worker_instances && !@worker_instances.empty?

    @worker_instances.each do |instance_id|
      begin
        Rails.logger.info "Retiring worker: #{instance_id}"
        worker_dns = private_dns_name(instance_id)
        workers_for_instance(instance_id).each { |worker| worker.unregister_worker if worker.idle? }
        $ec2.terminate_instances({ instance_ids: [instance_id] })
      rescue => e
        Rails.logger.error "Error retiring worker #{instance_id}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n\t")
      end
    end

    @worker_instances = []
  end

  private

  def instance_running? instance_id
    instance_state(instance_id) == "running"
  end

  def instance_state instance_id
    $ec2.describe_instances(instance_ids: [instance_id]).reservations.first.instances.map(&:state).map(&:name).first
  end

  def hostname instance_id
    $ec2.describe_instances({ instance_ids: [instance_id] }).reservations[0].instances[0].network_interfaces[0].association.public_dns_name
  end

  def private_dns_name instance_id
    $ec2.describe_instances({ instance_ids: [instance_id] }).reservations[0].instances[0].network_interfaces[0].private_ip_addresses[0].private_dns_name.split(".").first
  end

  def resque_worker_ip worker
    worker.id.split(":").first
  end

  def workers_for_instance instance_id
    Resque.workers.select { |worker| resque_worker_ip(worker) == private_dns_name(instance_id) }
  end
end
