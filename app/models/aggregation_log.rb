class AggregationLog < ActiveRecord::Base
  self.table_name = "aggregation_log"

  default_scope { order("trend_date DESC, updated_at DESC") }

  IN_PROGRESS = "in-progress"
  COMPLETED   = "completed"
  ERROR       = "error"

  def update_totals count_column:, where_column:, value:, addl_updates: {}
    klass     = aggregation_type.constantize
    tbl       = klass.arel_table

    sql       = tbl.project(
                  Arel::Distinct.new(tbl[count_column.to_sym]).count.as("num_releases"),
                  tbl[:stream_count].sum.as("stream_count"),
                  tbl[:album_download_count].sum.as("album_download_count"),
                  tbl[:song_download_count].sum.as("song_download_count")
                ).where(tbl[where_column.to_sym].eq(value))

    results   = klass.find_by_sql(sql).first

    update_attributes({
      stream_count:         results.stream_count,
      album_download_count: results.album_download_count,
      song_download_count:  results.song_download_count,
      num_releases:         results.num_releases
    }.merge(addl_updates))
  end

  def complete_aggregation column:, value:
    update_totals(
      column:       column,
      value:        value,
      addl_updates: { status: AggregationLog::COMPLETED }
    )
  end
end
