class AggregationRollupJob
  @queue        = :rollups
  BATCH_SIZE    = 10000

  # Order matters for GRANULARITIES (see next_keys)
  GRANULARITIES = ["date", "month", "year"]
  DIMENSIONS    = ["album", "person", "artist"]

  def self.perform date, dimension, granularity, enqueue_next_rollup=true
    raise "Invalid dimension #{dimension}: Accepted values are #{DIMENSIONS.join(", ")}"        unless DIMENSIONS.include?(dimension)
    raise "Invalid granularity #{granularity}: Accepted values are #{GRANULARITIES.join(", ")}" unless GRANULARITIES.include?(granularity)

    new(date: date, dimension: dimension, granularity: granularity).perform
  end

  def initialize date:, dimension:, granularity:, enqueue_next_rollup:
    @date                 = Date.strptime(date)
    @dimension            = dimension
    @granularity          = granularity
    @enqueue_next_rollup  = enqueue_next_rollup
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

    Rails.logger.info "Querying aggregate data: #{sql.to_sql}"
    data  = source_table.find_by_sql(sql)

    Rails.logger.info "Creating #{data.length} rows for #{target_table.to_s}"
    aggregated_rows = []
    data.each_with_index do |row, index|
      target_row = target_table.new
      row.attributes.reject { |k,v| k == "id" }.each { |col, val| target_row[col] = val }
      aggregated_rows << target_row

      if aggregated_rows.length >= BATCH_SIZE || index == (data.length - 1)
        Rails.logger.info "Importing #{aggregated_rows.length} rows into #{target_table.to_s}"
        target_table.import(aggregated_rows)
        aggregated_rows = []
      end
    end

    enqueue_next if @enqueue_next_rollup

    Rails.logger.info "Completed #{@dimension} by #{@granularity} aggregation"
    log_record.update_attributes(status: AggregationLog::COMPLETED)
  rescue Exception => e
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
    Rails.logger.info "Deleting old rollups for #{target_table.to_s}"
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
