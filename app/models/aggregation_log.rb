class AggregationLog < ActiveRecord::Base
  self.table_name = "aggregation_log"

  default_scope { order("trend_date DESC, updated_at DESC") }

  IN_PROGRESS = "in-progress"
  COMPLETED   = "completed"
  ERROR       = "error"
end
