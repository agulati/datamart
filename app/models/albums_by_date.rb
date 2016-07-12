class AlbumsByDate < ActiveRecord::Base
  self.table_name = "albums_by_date"

 def self.populate_aggregates date
    tds               = DetailSummary.arel_table
    geos              = Geo.arel_table
    countries         = Country.arel_table
    select            = [tds[:date], tds[:album_id], tds[:trans_type_id], geos[:country_code], countries[:name]]

    Rails.logger.info "Remove any previously aggregated data"
    where(trend_date: date).delete_all
    $redis.del("tc_trends::aggregation::albums::#{date}")

    Rails.logger.info "Query distinct album ids"
    album_ids = DetailSummary.select(:album_id).where(tds[:date].eq(date)).uniq
    Rails.logger.info "Found #{album_ids.length} albums, beginning aggregation"

    album_ids.each do |a|
      Rails.logger.debug("Enqueuing aggregation job for album #{a.album_id}")
      Resque.enqueue(AggregateAlbumByDateJob, date, a.album_id)
    end

    albums_processed = 0
    while albums_processed < album_ids.length
      albums_processed = $redis.scard("tc_trends::aggregation::albums::#{date}")
      Rails.logger.debug("Waiting for individual aggregation jobs to complete (#{albums_processed}/#{album_ids.length})")
      sleep(60)
    end

    Rails.logger.info "Completed album by date aggregation"
  end
end
