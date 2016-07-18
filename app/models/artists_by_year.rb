class ArtistsByYear < ActiveRecord::Base
  self.table_name = "artists_by_year"

  def self.source_table
    ArtistsByMonth
  end

  def self.source_columns
    [:artist_name]
  end
end
