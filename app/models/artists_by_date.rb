class ArtistsByDate < ActiveRecord::Base
  self.table_name = "artists_by_date"

  def self.source_table
    AlbumsByDate
  end

  def self.source_columns
    [:artist_name]
  end
end
