class Album < ActiveRecord::Base
  self.establish_connection :operational
  has_many :creatives, as: :creativeable
  belongs_to :person

  def primary_artists
    creatives.select { |c| c.role == "primary_artist" }.map(&:artist).map(&:name).join(" & ")
  end

  def featured_artists
    creatives.select { |c| c.role == "featuring" }.map(&:artist).map(&:name).join(" & ")
  end
end
