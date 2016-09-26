namespace :aggregations do
  desc "Create album aggregations for a specific date"
  task albums: :environment do
    raise "You must provide a date for aggregation in the format of YYYY-MM-DD or an array of [YYYY-MM-DD,YYYY-MM-DD,YYYY-MM-DD,...]" unless (ENV["DATE"] || ENV["DATES"])

    begin
      if ENV["DATE"]
        dates = [Date.parse(ENV["DATE"], "%Y-%m-%d")]
      else
        dates = ENV["DATES"].split(",").map { |date_string| Date.parse(date_string.strip, "%Y-%m-%d") }
      end

      dates.each { |date| Resque.enqueue(DailyAggregationJob, date, ENV["PERFORM_ROLLUPS"] || false) }
    rescue => e
      aggregation_log.update_attributes(status: "error")
      Rails.logger.info "Error aggregating album data for #{date}: #{e.message}"
    end
  end
end
