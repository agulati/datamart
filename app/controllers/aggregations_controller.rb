class AggregationsController < ApplicationController

  VALID_PARAMS = [:granularity, :dimension, :period]

  def index
    @aggregation_logs = AggregationLog.all.paginate(:page => params[:page], :per_page => params[:page_size] || 10)
  end

  def new
  end

  def create
    unless valid_params?(params)
      flash[:danger] = "You must provide a Dimension, Granularity, and Period to perform an aggregation."
      redirect_to new_aggregation_path and return
    end

    Aggregation.schedule_job(params[:dimension], params[:granularity], params[:period])

    flash[:success] = "Your aggregation has been scheduled. You can monitor the execution status <a href=\"/resque\">here</a>."
    redirect_to aggregations_path
  end

  private

  def valid_params? params
    valid = true
    VALID_PARAMS.each do |param|
      break unless valid
      valid = params[param] && !params[param].blank?
    end

    valid
  end
end
