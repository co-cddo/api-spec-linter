# frozen_string_literal: true

class GovernmentRulesetsController < ApplicationController
  include RulesetValidations
  before_action :clear_errors

  def show
    @issues = []
    @score = 100
    @counter = 0
    spectral_hash = JSON.parse(spectral_output)
    spectral_hash.each do |issue|
      newissue = {
        code: issue["code"],
        path: issue["path"],
        message: issue["message"],
        criticality: 5 - issue["severity"],
        range: issue["range"]
      }
      @counter += 1
      @score -= newissue[:criticality]
      @issues << newissue
    end
    @score = 0 if @score.negative?
    @issues.sort_by{|s| -s[:criticality]}
    @criticality = @issues.first[:criticality]
  end


  private

  def spectral_output
    Linters::Spectral.new(file_name: session[:oas_file_name], file_body: session[:oas_file_body]).lint_to_json
  end

  def clear_errors
    flash[:error] = nil
  end
end
