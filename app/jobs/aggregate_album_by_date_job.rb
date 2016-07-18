class AggregateAlbumByDateJob
  @queue = :aggregation

  def self.perform date, album_id
    AlbumsByDate.where(trend_date: date, album_id: album_id).delete_all

    album = Album.includes(:person, { creatives: :artist }).find(album_id)

    if Person.exclude_ids.include?(album.person_id)
      Rails.logger.info "Skipping album #{album_id} because owner is on exclude list"
    else
      trend_month   = Date.strptime(date).beginning_of_month.strftime("%Y%m").to_i
      trend_year    = Date.strptime(date).strftime("%Y").to_i
      tds           = DetailSummary.arel_table
      geos          = Geo.arel_table
      countries     = Country.arel_table
      select        = [tds[:date], tds[:album_id], tds[:trans_type_id], geos[:country_code], countries[:name]]

      sql           = tds.project(*select, geos[:qty].sum.as("qty"))
                        .join(geos).on(tds[:id].eq(geos[:trend_data_summary_id]))
                        .join(countries).on(geos[:country_code].eq(countries[:code]))
                        .where(tds[:date].eq(date))
                        .where(tds[:album_id].eq(album_id))
                        .group(*select)
                        .order(tds[:album_id], geos[:country_code])

      album_data    = DetailSummary.find_by_sql(sql)
      country_rows  = album_data.group_by(&:country_code)

      country_rows.keys.each do |country_code|
        aggregate_row = AlbumsByDate.new({
          trend_date:     date,
          trend_month:    trend_month,
          trend_year:     trend_year,
          album_id:       album.id,
          album_name:     album.name,
          album_type:     album.album_type,
          artist_name:    album.primary_artists,
          person_id:      album.person_id,
          person_name:    album.person.name,
          email_address:  album.person.email,
          country_code:   country_code,
          country_name:   country_rows[country_code].first.name
        })

        aggregate_row.stream_count          = country_rows[country_code].select { |row| row.trans_type_id == 3 }.sum(&:qty)
        aggregate_row.album_download_count  = country_rows[country_code].select { |row| row.trans_type_id == 2 }.sum(&:qty)
        aggregate_row.song_download_count   = country_rows[country_code].select { |row| row.trans_type_id == 1 }.sum(&:qty)

        aggregate_row.save!
      end

      $redis.srem("tc_trends::aggregation::albums::#{date}", album_id)
    end
  rescue => e
    AlbumsByDate.where(trend_date: date, album_id: album_id).delete_all
    raise e
  end
end
