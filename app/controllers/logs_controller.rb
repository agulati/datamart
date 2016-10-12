class LogsController < ApplicationController

  def index
    @day              = params[:day] || Date.today.to_s
    @refresh_interval = params[:refresh] || "60"
    @log_rows         = $redis.lrange("tc-trends:logger:#{@day}", 0, -1)
  end
end
