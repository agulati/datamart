class Geo < ActiveRecord::Base
  establish_connection TRENDS_DB
  self.table_name = 'geo_two'

  belongs_to :detail_summary, foreign_key: "trend_data_summary_id"
end
