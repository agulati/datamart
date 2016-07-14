class AlbumAggregatorJob
  @queue = :albums

  def self.perform date=Date.yesterday
    new(date).populate_aggregates
  end

  def initialize date
    @date               = date
    @working_queue_key  = "tc_trends::aggregation::albums::#{date}"
  end

  def populate_aggregates
    Rails.logger.info "Remove any previously aggregated data"
    AlbumsByDate.where(trend_date: @date).delete_all

    Rails.logger.info "Query distinct album ids"
    albums = DetailSummary.select(:album_id).where(date: @date).distinct
    @num_albums = albums.length
    Rails.logger.info "Found #{@num_albums} albums, beginning aggregation"

    albums.each do |album|
      $redis.sadd(@working_queue_key, album.album_id)
      Resque.enqueue(AggregateAlbumByDateJob, @date, album.album_id)
    end

    repeat_count        = 0
    previous_remaining  = 0
    while ( num_remaining = $redis.scard(@working_queue_key) ) > 0
      repeat_count += 1 if previous_remaining == num_remaining

      if repeat_count >= 5
        Rails.logger.info "Re-queueing remaining albums"
        $redis.smembers(@working_queue_key).each { |a| Resque.enqueue(AggregateAlbumByDateJob, @date, a) }
        repeat_count = 0
      end

      previous_remaining = num_remaining
      Rails.logger.info "Waiting for aggregation to complete (#{num_remaining}/#{@num_albums} remaining)"
      sleep(60)
    end

    Rails.logger.info "Completed album by date aggregation"
  end
end
