
class GovernmentRulesetsController < ApplicationController
  include RulesetValidations
  before_action :clear_errors

  def show
    oas_file = session[:oas_file]
    @spectral_results = JSON.parse(Linters::Spectral.new(file: oas_file).lint_to_json)
  end

  private

  def clear_errors
    flash[:error] = nil
  end
end
