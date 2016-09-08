class ScalingService

  MAX_INSTANCES     = 10
  JOBS_PER_INSTANCE = 20

  def initialize num_jobs:
    @num_jobs = num_jobs
  end

  def scale_workers
    response = $ec2.run_instances({
      image_id:           AWS_CONFIG["image_id"],
      min_count:          1,
      max_count:          num_instances,
      key_name:           AWS_CONFIG["key_name"],
      instance_type:      AWS_CONFIG["instance_type"],
      network_interfaces: [ { subnet_id: AWS_CONFIG["subnet_id"], device_index: 0, associate_public_ip_address: true, groups: [ AWS_CONFIG["security_group"] ] } ]
    })

    Rails.logger.info "Launched #{response.instances.length} worker instances"

    @worker_instances = response.instances.map(&:instance_id)

    response.instances.each do |instance|
      until instance_running?(instance.instance_id) do
        Rails.logger.info "Waiting for #{instance.instance_id} to start. Current status: #{instance_state(instance.instance_id)}"
        sleep(10)
      end

      $jenkins_client.job.build(JENKINS_CONFIG["job"], { host: hostname(instance.instance_id) }, { 'build_start_timeout' => 30 } )
    end
  end

  def retire_workers
    $ec2.terminate_instances({ instance_ids: @worker_instances }) if @worker_instances && !@worker_instances.empty?
  end

  private

  def num_instances
    @num_instances = [(@num_jobs / JOBS_PER_INSTANCE) + ( @num_jobs % JOBS_PER_INSTANCE > 0 ? 1 : 0), MAX_INSTANCES].min
  end

  def instance_running? instance_id
    instance_state(instance_id) == "running"
  end

  def instance_state instance_id
    $ec2.describe_instances(instance_ids: [instance_id]).reservations.first.instances.map(&:state).map(&:name).first
  end

  def hostname instance_id
    $ec2.describe_instances({ instance_ids: [instance_id] }).reservations[0].instances[0].network_interfaces[0].association.public_dns_name
  end
end
