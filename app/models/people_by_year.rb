class PeopleByYear < ActiveRecord::Base
  self.table_name = "people_by_year"

  def self.source_table
    PeopleByMonth
  end

  def self.source_columns
    [:person_id, :person_name, :email_address]
  end
end
