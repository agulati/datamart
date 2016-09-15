class DailyAggregationJob
  @queue = :scheduled

  def self.perform date=Date.yesterday
    new(date).populate_aggregates
  end

  def initialize date
    @date               = date
    @working_queue_key  = "tc_trends::aggregation::albums::#{date}"
  end

  def populate_aggregates
    log_record = AggregationLog.create({
      trend_date:       @date,
      aggregation_type: "AlbumsByDate",
      status:           AggregationLog::IN_PROGRESS
    })

    Rails.logger.info "Remove any previously aggregated data"
    $redis.del(@working_queue_key)
    AlbumsByDate.where(trend_date: @date).delete_all

    Rails.logger.info "Query distinct album ids"
    albums      = DetailSummary.select(:album_id).where(date: @date).distinct
    @num_albums = albums.length
    Rails.logger.info "Found #{@num_albums} albums, beginning aggregation for #{@date}"

    scaler = ScalingService.new(num_jobs: albums.length)
    scaler.scale_workers

    albums.each do |album|
      $redis.sadd(@working_queue_key, album.album_id)
      Resque.enqueue(AggregateAlbumByDateJob, @date, album.album_id)
    end

    repeat_count        = 0
    previous_remaining  = 0
    retry_count         = 0
    while ( num_remaining = $redis.scard(@working_queue_key) ) > 0 && retry_count < 5
      repeat_count += 1 if previous_remaining == num_remaining

      if repeat_count >= 5
        retry_count += 1
        Rails.logger.info "Re-queueing remaining albums (#{retry_count}/5)"
        $redis.smembers(@working_queue_key).each { |a| Resque.enqueue(AggregateAlbumByDateJob, @date, a) }
        repeat_count = 0
      end

      previous_remaining = num_remaining
      Rails.logger.info "Waiting for aggregation to complete (#{num_remaining}/#{@num_albums} remaining)"
      sleep(60)
    end

    Rails.logger.info "Completed album by date aggregation"
    log_record.update_attributes(status: AggregationLog::COMPLETED)

    Resque.enqueue(AggregationRollupJob, @date, "album", "month")
    Resque.enqueue(AggregationRollupJob, @date, "person", "date")
    Resque.enqueue(AggregationRollupJob, @date, "artist", "date")
  rescue => e
    Rails.logger.error "Error completing album aggregation for #{@date}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n\t")
    log_record.update_attributes(status: AggregationLog::ERROR)
    raise e
  ensure
    scaler.retire_workers if scaler
  end
end
