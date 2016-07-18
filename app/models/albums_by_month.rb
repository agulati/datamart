class AlbumsByMonth < ActiveRecord::Base
  self.table_name = "albums_by_month"

  def self.source_table
    AlbumsByDate
  end

  def self.source_columns
    [:album_id, :album_name, :album_type]
  end
end
