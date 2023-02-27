# frozen_string_literal: true

class GovernmentRulesetsController < ApplicationController
  include RulesetValidations
  before_action :clear_errors

  def show
    @spectral_results = JSON.parse(
      Linters::Spectral.new(
        file_name: session[:oas_file_name],
        file_body: session[:oas_file_body]
        ).lint_to_json
    )
  end

  private

  def clear_errors
    flash[:error] = nil
  end
end
