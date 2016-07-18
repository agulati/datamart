class ArtistsByMonth < ActiveRecord::Base
  self.table_name = "artists_by_month"

  def self.source_table
    ArtistsByDate
  end

  def self.source_columns
    [:artist_name]
  end
end
