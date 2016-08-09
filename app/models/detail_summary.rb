class DetailSummary < ActiveRecord::Base
  establish_connection TRENDS_DB
  self.table_name = 'trend_data_summary'

  has_many    :geos, foreign_key: "trend_data_summary_id"
  belongs_to  :trans_type
end
