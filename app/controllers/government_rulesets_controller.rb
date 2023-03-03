# frozen_string_literal: true

class GovernmentRulesetsController < ApplicationController
  include RulesetValidations
  before_action :clear_errors

  def show
    upload = Upload.find(session[:upload_id])
    return redirect_to root_path, alert: "Please re upload your file" if upload.nil?

    @spectral_results =
      JSON.parse(
        Linters::Spectral.new(upload:).lint_to_json
      )
  end

  private

  def clear_errors
    flash[:error] = nil
  end
end
