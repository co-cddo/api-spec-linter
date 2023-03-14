# frozen_string_literal: true

class GovernmentRulesetsController < ApplicationController
  before_action :clear_errors

  def show
    @breadcrumbs = { Home: root_path, Uploads: new_upload_path, Rulesets: rulesets_path, Report:"#"}
    @upload = Upload.find(session[:upload_id])
    @ruleset_name = params[:ruleset_name]
    return redirect_to root_path, alert: "Please re-upload your file" if upload.nil?

    @issues = []
    @score = 100
    issues = JSON.parse(spectral_output)
    issues.each do |issue|
      newissue = {
        code: issue["code"],
        path: issue["path"],
        message: issue["message"],
        criticality: 4 - issue["severity"],
        line: issue["range"]["start"]["line"],
        character: issue["range"]["start"]["character"]
      }
      @score -= newissue[:criticality]
      @issues << newissue
    end
    @filename = @upload.oas_file.filename
    @score = 0 if @score.negative?
    @issues = @issues.sort_by{|s| -s[:criticality]}
    @criticality = @issues.first[:criticality]

    @errors = @issues.select{ |issue| issue[:criticality] == 4 }
    @warnings = @issues.select{ |issue| issue[:criticality] == 3 }
    @information = @issues.select{ |issue| issue[:criticality] == 2 }
    @hints = @issues.select{ |issue| issue[:criticality] == 1 }

  end


  private

  attr_accessor :upload, :ruleset_name

  def spectral_output
    Linters::Spectral.new(upload:, ruleset_name:).lint_to_json
  end

  def clear_errors
    flash[:error] = nil
  end
end
