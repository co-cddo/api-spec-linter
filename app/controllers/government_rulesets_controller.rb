# frozen_string_literal: true

class GovernmentRulesetsController < ApplicationController
  before_action :clear_errors

  def show
    @upload = Upload.find(session[:upload_id])
    return redirect_to root_path, alert: "Please re-upload your file" if upload.nil?

    @issues = []
    @score = 100
    issues = JSON.parse(spectral_output)
    issues.each do |issue|
      newissue = {
        code: issue["code"],
        path: issue["path"],
        message: issue["message"],
        criticality: 5 - issue["severity"],
        range: issue["range"],
        remediation: URI.join(ENV["WIKI_URL"], issue["code"]).to_s
      }
      @score -= newissue[:criticality]
      @issues << newissue
    end
    @score = 0 if @score.negative?
    @issues.sort_by{|s| -s[:criticality]}
    @criticality = @issues.first[:criticality]

  end


  private

  attr_accessor :upload

  def spectral_output
    Linters::Spectral.new(upload:).lint_to_json
  end

  def clear_errors
    flash[:error] = nil
  end
end
