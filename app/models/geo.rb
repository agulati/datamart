class Geo < ActiveRecord::Base
  self.table_name = 'geo_two'
  belongs_to :detail_summary, foreign_key: "trend_data_summary_id"
end
