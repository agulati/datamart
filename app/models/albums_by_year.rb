class AlbumsByYear < ActiveRecord::Base
  self.table_name = "albums_by_year"

  def self.populate_aggregates date
    trend_year  = date.strftime("%Y").to_i

    Rails.logger.info "Remove any previously aggregated data"
    where(trend_year: trend_year).delete_all

    abm         = AlbumsByMonth.arel_table
    select      = abm[:trend_year], abm[:country_code], abm[:country_name], abm[:album_id], abm[:album_name], abm[:album_type]
    aggregates  = abm[:stream_count].sum.as("stream_count"), abm[:album_download_count].sum.as("album_download_count"), abm[:song_download_count].sum.as("song_download_count")
    sql         = abm.project( *(select + aggregates) )
                    .where(abm[:trend_year].eq(trend_year))
                    .group(*select)

    Rails.logger.info "Query aggregated monthly data"
    results     = AlbumsByMonth.find_by_sql(sql)
    results.each do |row|
      monthly_aggregate_row = create({
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
    Rails.logger.info "Completed yearly aggregation"
  rescue => e
    where(trend_year: trend_year).delete_all
    raise e
  end
end
