class Aggregation

  def self.schedule_job dimension, granularity, period
    send("aggregate_#{dimension}_#{granularity}".to_sym, period)
  end

  def self.aggregate_album_date period
    Resque.enqueue(DailyAggregationJob, period, false)
  end

  def self.method_missing(method_sym, *arguments, &block)
    if method_sym.to_s =~ /^aggregate_(.*)$/
      dim, gran = $1.split("_")
      Resque.enqueue(ScheduleAggregationRollupJob, arguments.first, dim, gran, false)
    else
      super
    end
  end
end
