class AlbumsByYear < ActiveRecord::Base
  self.table_name = "albums_by_year"

  def self.source_table
    AlbumsByMonth
  end

  def self.source_columns
    [:album_id, :album_name, :album_type]
  end
end
