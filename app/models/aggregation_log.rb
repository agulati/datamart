class AggregationLog < ActiveRecord::Base
  self.table_name = "aggregation_log"

  IN_PROGRESS = "in-progress"
  COMPLETED   = "completed"
  ERROR       = "error"
end
