class AlbumsByMonth < ActiveRecord::Base
  self.table_name = "albums_by_month"

  def self.populate_aggregates date
    trend_month         = date.strftime("%Y%m").to_i
    trend_month_display = date.strftime("%B %Y")
    trend_year          = date.strftime("%Y").to_i

    Rails.logger.info "Remove any previously aggregated data"
    where(trend_month: trend_month).delete_all

    abd         = AlbumsByDate.arel_table
    select      = abd[:trend_month], abd[:country_code], abd[:country_name], abd[:album_id], abd[:album_name], abd[:album_type]
    aggregates  = abd[:stream_count].sum.as("stream_count"), abd[:album_download_count].sum.as("album_download_count"), abd[:song_download_count].sum.as("song_download_count")
    sql         = abd.project( *(select + aggregates) )
                    .where(abd[:trend_month].eq(trend_month))
                    .group(*select)

    Rails.logger.info "Query aggregated daily data"
    results     = AlbumsByDate.find_by_sql(sql)
    results.each do |row|
      monthly_aggregate_row = create({
        trend_month:          trend_month,
        trend_month_display:  trend_month_display,
        trend_year:           trend_year,
        country_code:         row.country_code,
        country_name:         row.country_name,
        album_id:             row.album_id,
        album_name:           row.album_name,
        album_type:           row.album_type,
        stream_count:         row.stream_count,
        album_download_count: row.album_download_count,
        song_download_count:  row.song_download_count
      })
    end
    Rails.logger.info "Completed monthly aggregation"
  rescue => e
    where(trend_month: trend_month).delete_all
    raise e
  end
end
