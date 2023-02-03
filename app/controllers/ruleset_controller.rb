# frozen_string_literal: true
class RulesetController < ApplicationController
  before_action :set_ruleset_type, only: %i[new create]

  def new
    render @ruleset_name
  end

  def create
    if ruleset_params[:oas_file].nil?
      flash[:error] = "Please upload a file"
      return render @ruleset_name
    end

    # Here we can call our 42 crunch or spectral service

    render json: { message: "File uploaded successfully" }
  end

  private

  def set_ruleset_type
    @ruleset_name = ruleset_params[:which_ruleset]
  end

  def ruleset_params
    params.permit(:oas_file, :which_ruleset)
  end
end
