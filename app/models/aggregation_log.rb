class AggregationLog < ActiveRecord::Base
  self.table_name = "aggregation_log"

  default_scope { order("trend_date DESC, updated_at DESC") }

  IN_PROGRESS = "in-progress"
  COMPLETED   = "completed"
  ERROR       = "error"

  def calculate_totals_and_complete column:, value:
    klass = aggregation_type.constantize
    tbl   = klass.arel_table

    sql = tbl.project(
      tbl[:id].count.as("num_releases"),
      tbl[:stream_count].sum.as("stream_count"),
      tbl[:album_download_count].sum.as("album_download_count"),
      tbl[:song_download_count].sum.as("song_download_count")
    ).where(tbl[column.to_sym].eq(value))

    results = klass.find_by_sql(sql).first

    update_attributes({
      stream_count:         results.stream_count,
      album_download_count: results.album_download_count,
      song_download_count:  results.song_download_count,
      num_releases:         results.num_releases,
      status:               AggregationLog::COMPLETED
    })
  end
end
