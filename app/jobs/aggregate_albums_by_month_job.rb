class AggregateAlbumsByMonthJob
  @queue = :albums

  def self.perform date
    date                = Date.strptime(date)
    trend_month         = date.beginning_of_month.strftime("%Y%m").to_i
    trend_month_display = date.beginning_of_month.strftime("%B %Y")
    trend_year          = date.strftime("%Y").to_i

    AlbumsByMonth.where(trend_month: trend_month).delete_all

    log_record = AggregationLog.create({
      trend_date:       date,
      aggregation_type: "AlbumsByMonth",
      status:           AggregationLog::IN_PROGRESS
    })

    abd     = AlbumsByDate.arel_table
    select  = [abd[:album_id], abd[:album_name], abd[:album_type], abd[:country_code], abd[:country_name]]
    sql     = abd.project(*select, abd[:stream_count].sum.as("stream_count"), abd[:album_download_count].sum.as("album_download_count"), abd[:song_download_count].sum.as("song_download_count"))
                .where(abd[:trend_month].eq(trend_month))
                .group(*select)

    albums  = AlbumsByDate.find_by_sql(sql)
    albums.each do |album|
      AlbumsByMonth.create({
        trend_month:          trend_month,
        trend_month_display:  trend_month_display,
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

    Resque.enqueue(AggregateAlbumsByYearJob, date)

    Rails.logger.info "Completed album by month aggregation"
    log_record.update_attributes(status: AggregationLog::COMPLETED)
  rescue => e
    Rails.logger.error "Error completing album by month aggregation for #{date}: #{e.message}"
    log_record.update_attributes(status: AggregationLog::ERROR)
    raise e
  end
end
