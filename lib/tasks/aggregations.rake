namespace :aggregations do
  desc "Create album aggregations for a specific date"
  task albums: :environment do
    raise "You must provide a date for aggregation in the format of YYYY-MM-DD" unless ENV["DATE"]

    begin
      date = Date.parse(ENV["DATE"], "%Y-%m-%d")
      Resque.enqueue(DailyAggregationJob, date)
    rescue => e
      aggregation_log.update_attributes(status: "error")
      Rails.logger.info "Error aggregating album data for #{date}: #{e.message}"
    end
  end
end
