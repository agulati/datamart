class PeopleByMonth < ActiveRecord::Base
  self.table_name = "people_by_month"

  def self.source_table
    PeopleByDate
  end

  def self.source_columns
    [:person_id, :person_name, :email_address]
  end
end
