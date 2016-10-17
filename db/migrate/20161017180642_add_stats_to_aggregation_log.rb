class AddStatsToAggregationLog < ActiveRecord::Migration[5.0]
  def change
    add_column :aggregation_log, :num_releases,         :integer
    add_column :aggregation_log, :stream_count,         :integer
    add_column :aggregation_log, :album_download_count, :integer
    add_column :aggregation_log, :song_download_count,  :integer
  end
end
