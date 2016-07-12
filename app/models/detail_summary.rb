class DetailSummary < ActiveRecord::Base
  self.table_name = 'trend_data_summary'
  has_many :geos, foreign_key: "trend_data_summary_id"
  belongs_to :trans_type
end
