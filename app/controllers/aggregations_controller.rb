class AggregationsController < ApplicationController

  def index
    @aggregation_logs = AggregationLog.all.paginate(:page => params[:page], :per_page => params[:page_size] || 10)
  end
end
