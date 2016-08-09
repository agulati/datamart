class Album < ActiveRecord::Base
  establish_connection TUNECORE_DB

  has_many    :creatives, as: :creativeable
  belongs_to  :person

  def primary_artists
    creatives.select { |c| c.role == "primary_artist" }.map(&:artist).map(&:name).join(" & ")
  end

  def featured_artists
    creatives.select { |c| c.role == "featuring" }.map(&:artist).map(&:name).join(" & ")
  end
end
