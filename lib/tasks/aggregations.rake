namespace :aggregations do
  desc "Create album aggregations for a specific date"
  task albums: :environment do
    begin
      date            = ENV["DATE"].nil? ? Date.yesterday : Date.parse(ENV["DATE"], "%Y-%m-%d")
      aggregation_log = AggregationLog.create(trend_date: date, aggregation_type: "album", status: "processing")

      Rails.logger.info "Aggregating album data for #{date}"

      AlbumsByDate.populate_aggregates(date)
      AlbumsByMonth.populate_aggregates(date)
      AlbumsByYear.populate_aggregates(date)

      aggregation_log.update_attributes(status: "completed")
      Rails.logger.info "Completed aggregating album data for #{date}"
    rescue => e
      aggregation_log.update_attributes(status: "error")
      Rails.logger.info "Error aggregating album data for #{date}: #{e.message}"
    end
  end
end
