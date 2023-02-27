# frozen_string_literal: true

class GovernmentRulesetsController < ApplicationController
  include RulesetValidations
  before_action :clear_errors

  def show
    oas_file_body = session[:oas_file_body]
    oas_file_name = session[:oas_file_name]
    Tempfile.open(oas_file_name) do |oas_file|
      oas_file.write(oas_file_body)
      oas_file.rewind
      @spectral_results = JSON.parse(Linters::Spectral.new(file: oas_file).lint_to_json)
    end
  end

  private

  def clear_errors
    flash[:error] = nil
  end
end
