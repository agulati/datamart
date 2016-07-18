class AggregateAlbumsByYearJob
  @queue = :albums

  def self.perform date
    date        = Date.strptime(date)
    trend_year  = date.strftime("%Y").to_i

    AlbumsByYear.where(trend_year: trend_year).delete_all

    log_record = AggregationLog.create({
      trend_date:       date,
      aggregation_type: "AlbumsByYear",
      status:           AggregationLog::IN_PROGRESS
    })

    abm     = AlbumsByMonth.arel_table
    select  = [abm[:album_id], abm[:album_name], abm[:album_type], abm[:country_code], abm[:country_name]]
    sql     = abm.project(*select, abm[:stream_count].sum.as("stream_count"), abm[:album_download_count].sum.as("album_download_count"), abm[:song_download_count].sum.as("song_download_count"))
                .where(ab[:trend_year].eq(trend_year))
                .group(*select)

    albums  = AlbumsByMonth.find_by_sql(sql)
    albums.each do |album|
      AlbumsByYear.create({
        trend_year:           trend_year,
        album_id:             album.album_id,
        album_name:           album.album_name,
        album_type:           album.album_type,
        country_code:         album.country_code,
        country_name:         album.country_name,
        stream_count:         album.stream_count,
        album_download_count: album.album_download_count,
        song_download_count:  album.song_download_count
      })
    end

    Rails.logger.info "Completed album by month aggregation"
    log_record.update_attributes(status: AggregationLog::COMPLETED)
  rescue => e
    Rails.logger.error "Error completing album by month aggregation for #{date}: #{e.message}"
    log_record.update_attributes(status: AggregationLog::ERROR)
    raise e
  end
end
