class LogsController < ApplicationController

  def index
    keys = $redis.keys("tc-trends:logger*")

    @log_rows = {}
    keys.sort { |a,b| b <=> a }.each do |day_key|
      day = day_key.split(":").last
      @log_rows[day] = $redis.lrange(day_key, 0, -1)
    end
  end

  def show
  end
end
