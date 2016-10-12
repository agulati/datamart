class DailyAggregationJob
  @queue = :scheduled_daily

  MAX_INSTANCES         = 50
  WORKERS_PER_INSTANCE  = 2

  def self.perform date=Date.yesterday, perform_rollups=false
    new(date: date, perform_rollups: perform_rollups).populate_aggregates
  end

  def initialize date:, perform_rollups:
    @date               = date
    @working_queue_key  = "tc_trends::aggregation::albums::#{date}"
    @perform_rollups    = perform_rollups
  end

  def populate_aggregates
    log_record = AggregationLog.where(
      trend_date: @date,
      aggregation_type: "AlbumsByDate"
    ).first_or_create!
    log_record.update_attributes(status: AggregationLog::IN_PROGRESS)

    Rails.logger.info "Remove any previously aggregated data"
    $redis.del(@working_queue_key)
    AlbumsByDate.where(trend_date: @date).delete_all

    Rails.logger.info "Query distinct album ids"
    albums      = DetailSummary.select(:album_id).where(date: @date).distinct
    @num_albums = albums.length

    if @num_albums > 0
      Rails.logger.info "Found #{@num_albums} albums, beginning aggregation for #{@date}"
    else
      Rails.logger.info "No data available yet for #{@data}" and return
    end

    scaler = ScalingService.new(queue: "albums", num_instances: servers_to_scale, num_processes: WORKERS_PER_INSTANCE )
    scaler.scale_workers

    albums.each do |album|
      $redis.sadd(@working_queue_key, album.album_id)
      Resque.enqueue(AggregateAlbumByDateJob, @date, album.album_id)
    end

    repeat_count        = 0
    previous_remaining  = 0
    retry_count         = 0
    while ( num_remaining = $redis.scard(@working_queue_key) ) > 0 && retry_count < 3
      repeat_count += 1 if previous_remaining == num_remaining

      if repeat_count >= 3
        retry_count += 1
        Rails.logger.info "Re-queueing remaining albums (#{retry_count}/3 attempts)"
        $redis.smembers(@working_queue_key).each { |a| Resque.enqueue(AggregateAlbumByDateJob, @date, a.to_i) }
        repeat_count = 0
      end

      previous_remaining = num_remaining
      Rails.logger.info "Waiting for aggregation to complete (#{num_remaining}/#{@num_albums} remaining)"
      sleep(60)
    end

    if num_remaining == 0
      Rails.logger.info "Completed album by date aggregation"
      log_record.update_attributes(status: AggregationLog::COMPLETED)
    else
      Rails.logger.info "Not all albums were successfully aggregated"
      log_record.update_attributes(status: AggregationLog::ERROR)
    end

    if @perform_rollups && num_remaining == 0
      [ { granularity: "month", dimension: "album" },
        { granularity: "date", dimension: "person" },
        { granularity: "date", dimension: "artist" } ].each do |rollup|
        Resque.enqueue(ScheduleAggregationRollupJob, @date, rollup[:dimension], rollup[:granularity], true)
      end
    end
  rescue => e
    Rails.logger.error "Error completing album aggregation for #{@date}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n\t")
    log_record.update_attributes(status: AggregationLog::ERROR)
    raise e
  ensure
    scaler.retire_workers if scaler
  end

  def servers_to_scale
    [@num_albums / WORKERS_PER_INSTANCE, MAX_INSTANCES].min
  end
end
