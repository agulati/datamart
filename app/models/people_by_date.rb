class PeopleByDate < ActiveRecord::Base
  self.table_name = "people_by_date"

  def self.source_table
    AlbumsByDate
  end

  def self.source_columns
    [:person_id, :person_name, :email_address]
  end
end
