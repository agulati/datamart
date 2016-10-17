class AggregationExclusion < ActiveRecord::Base

  validates :exclusion_id, uniqueness: { scope: :exclusion_type, message: ->(o,d) { "#{o.exclusion_type} / #{o.exclusion_id} already exists as an exclusion." } }

  def self.exclude_album? album
    tbl           = self.arel_table
    album_where   = tbl.grouping(tbl[:exclusion_type].eq("Album").and(tbl[:exclusion_id].eq(album.id)))
    person_where  = tbl.grouping(tbl[:exclusion_type].eq("Album").and(tbl[:exclusion_id].eq(album.person.id)))

    !where(album_where.or(person_where)).empty?
  end
end
