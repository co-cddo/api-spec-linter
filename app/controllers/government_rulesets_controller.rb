
class GovernmentRulesetsController < ApplicationController
  include RulesetValidations

  before_action :validate_file_upload!, only: [:create]
  before_action :clear_errors

  def new
  end

  def create
    @spectral_results = JSON.parse(Linters::Spectral.new(file: ruleset_params[:oas_file]).lint_to_json)

    render 'show'
  end

  private

  def ruleset_params
    params.permit(:oas_file)
  end

  def clear_errors
    flash[:error] = nil
  end
end