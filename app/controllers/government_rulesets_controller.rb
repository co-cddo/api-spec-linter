# frozen_string_literal: true

class GovernmentRulesetsController < ApplicationController
  before_action :clear_errors

  def show
    @breadcrumbs = { Home: root_path, Uploads: new_upload_path, Rulesets: rulesets_path, Report:"#"}
    @upload = Upload.find(session[:upload_id])
    @ruleset_name = params[:ruleset_name]
    return redirect_to root_path, alert: "Please re-upload your file" if upload.nil?

    @issues = build_issues_array

    @filename = @upload.oas_file.filename
    @issues = @issues.sort_by{|s| -s[:criticality]}

    @errors = @issues.select{ |issue| issue[:criticality] == 4 }
    @warnings = @issues.select{ |issue| issue[:criticality] == 3 }
    @information = @issues.select{ |issue| issue[:criticality] == 2 }
    @hints = @issues.select{ |issue| issue[:criticality] == 1 }

    @errors = @issues.select{ |issue| issue[:criticality] == 4 }
    @warnings = @issues.select{ |issue| issue[:criticality] == 3 }
    @information = @issues.select{ |issue| issue[:criticality] == 2 }
    @hints = @issues.select{ |issue| issue[:criticality] == 1 }

  end


  private

  attr_accessor :upload, :ruleset_name

  def build_issues_array
    issue_array = []
    issues = JSON.parse(spectral_output)
    issues.each do |issue|
      #Check if the issue already exists in the list
      existing = issue_array.find_index{ |i| i[:code] == issue["code"] }
      if existing
        #If the issue exists, just add the line number and sort
        issue_array[existing][:lines].push(issue["range"]["start"]["line"]).sort
      else
        #If the issue doesn't exist, create a new one from this template
        new_issue = {
          code: issue["code"],
          path: issue["path"],
          message: issue["message"],
          criticality: 4 - issue["severity"],
          lines: [issue["range"]["start"]["line"]]
        }
        issue_array << new_issue
      end
    end
    issue_array
  end

  def spectral_output
    Linters::Spectral.new(upload:, ruleset_name:).lint_to_json
  end

  def clear_errors
    flash[:error] = nil
  end
end
