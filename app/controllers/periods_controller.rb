class PeriodsController < ApplicationController

  def index
    @periods = send(params[:granularity].to_sym)
    @periods.unshift({ display: "", value: "" })
  end

  private

  def date
    days = []
    60.times do |x|
      date = Date.today - x.days
      days << { display: date.strftime("%m/%d/%Y"), value: date.strftime("%Y-%m-%d") }
    end
    days
  end

  def month
    months = []
    12.times do |x|
      date = Date.today.beginning_of_month - x.months
      months << { display: date.strftime("%B %Y"), value: date.strftime("%Y-%m-%d") }
    end
    months
  end

  def year
    years = []
    10.times do |x|
      year = Date.today.year - x
      years << { display: year, value: Date.new(year,1,1).strftime("%Y-%m-%d") }
    end
    years
  end
end
