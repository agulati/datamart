class ScheduleAggregationRollupJob
  @queue = :scheduled_rollup

  def self.perform date, dimension, granularity, enqueue_next_rollup
    scaler = ScalingService.new(queue: "rollups", num_instances: 1, num_processes: 1)
    scaler.scale_workers

    process_token = SecureRandom.uuid
    $redis.set(process_token, "in-progress")
    Resque.enqueue(AggregationRollupJob, date, dimension, granularity, enqueue_next_rollup, process_token)

    while( !$redis.get(process_token).nil? > 0 ) do
      Rails.logger.info "Waiting for rollup to complete (#{date.to_s}/#{dimension}/#{granularity})"
      sleep(300)
    end

    scaler.retire_workers
  end
end
