class AggregationRollupJob
  @queue = :rollups

  # Order matters for GRANULARITIES (see next_keys)
  GRANULARITIES = ["date", "month", "year"]
  DIMENSIONS    = ["album", "person", "artist"]

  def self.perform date, dimension, granularity
    raise "Invalid dimension #{dimension}: Accepted values are #{DIMENSIONS.join(", ")}"        unless DIMENSIONS.include?(dimension)
    raise "Invalid granularity #{granularity}: Accepted values are #{GRANULARITIES.join(", ")}" unless GRANULARITIES.include?(granularity)

    new(date, dimension, granularity).perform
  end

  def initialize date, dimension, granularity
    @date         = Date.strptime(date)
    @dimension    = dimension
    @granularity  = granularity
  end

  def perform
    reset_data

    log_record = AggregationLog.create({
      trend_date:       @date,
      aggregation_type: "#{@dimension.capitalize.pluralize}By#{@granularity.capitalize}",
      status:           AggregationLog::IN_PROGRESS
    })

    src     = source_table.arel_table
    select  = key_columns + target_table.source_columns + [:country_code, :country_name]
    sql     = src.project(*select.map { |col| src[col] }, src[:stream_count].sum.as("stream_count"), src[:album_download_count].sum.as("album_download_count"), src[:song_download_count].sum.as("song_download_count"))
                .where(src[key_columns.first].eq(send("#{@granularity}_key".to_sym)))
                .group(*select)

    data  = source_table.find_by_sql(sql)

    Rails.logger.info "Creating #{data.length} rows in #{target_table.to_s}"
    data.each_with_index do |row, index|
      target_row = target_table.new
      row.attributes.reject { |k,v| k == "id" }.each { |col, val| target_row[col] = val }
      target_row.save!
      Rails.logger.info "Saved #{index + 1}/#{data.length} rows" if (index + 1) % 100 == 0
    end

    enqueue_next

    Rails.logger.info "Completed #{@dimension} by #{@granularity} aggregation"
    log_record.update_attributes(status: AggregationLog::COMPLETED)
  rescue => e
    Rails.logger.error "Error completing #{@dimension} by #{@granularity} aggregation for #{@date}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n\t")
    log_record.update_attributes(status: AggregationLog::ERROR)
    raise e
  end

  def target_table
    @target_table ||= "#{@dimension.capitalize.pluralize}By#{@granularity.capitalize}".constantize
  end

  def source_table
    target_table.source_table
  end

  def reset_data
    target_table.where(target_table.arel_table[key_columns.first].eq(send("#{@granularity}_key".to_sym))).delete_all
  end

  def key_columns
    if @key_columns.blank?
      @key_columns = ["trend_#{@granularity}".to_sym]
      next_keys.each { |k| @key_columns << "trend_#{k}".to_sym }
    end
    @key_columns
  end

  def date_key
    @date.strftime("%Y-%m-%d")
  end

  def month_key
    @date.strftime("%Y%m").to_i
  end

  def year_key
    @date.strftime("%Y").to_i
  end

  def next_keys
    @next_keys ||= GRANULARITIES.slice(GRANULARITIES.index(@granularity)+1, GRANULARITIES.length)
  end

  def has_next_key?
    !next_keys.empty?
  end

  def enqueue_next
    Resque.enqueue(AggregationRollupJob, @date, @dimension, next_keys.first) if has_next_key?
  end
end
