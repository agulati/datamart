class ExclusionsController < ApplicationController

  VALID_PARAMS = [:exclusion_type, :exclusion_id]

  def index
    @exclusions = AggregationExclusion.all.paginate(:page => params[:page], :per_page => params[:page_size] || 10)
  end

  def create
    unless valid_params?(params)
      flash[:danger] = "You must provide an Exclusion Type and Exclusion ID to create a new exclusion."
      redirect_to exclusions_path and return
    end

    @new_exclusion = AggregationExclusion.new(params.permit(VALID_PARAMS))

    unless @new_exclusion.save
      flash[:danger] = @new_exclusion.errors.messages.values.flatten.join("<br/>")
      redirect_to exclusions_path and return
    end

    flash[:success] = "Your exclusion has been created."
  end

  def destroy
    @deleted_id = params[:id]
    AggregationExclusion.find(@deleted_id).destroy
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
