# frozen_string_literal: true

class SecurityRulesetsController < ApplicationController
  include RulesetValidations
  before_action :clear_errors

  def show
    crunch_hash = JSON.parse(crunch42_data)
    @score = crunch_hash['score']
    @openapi = crunch_hash['openapiState']
    @counter = crunch_hash['issueCounter']
    @criticality = crunch_hash['criticality']
    @issues = crunch_hash['data']['issues'].map do |_key, issue|
      lines = issue['issues'].pluck('pointer')
      [issue['criticality'],issue['description'], lines]
    end
  end

  private

  def crunch42_data
    return File.read('fakecrunchresults.json') if ENV['BYPASS_API'] == 'true'

    oas_file_body = session[:oas_file_body]
    oas_file_name = session[:oas_file_name]
    Tempfile.open(oas_file_name) do |oas_file|
      oas_file.write(oas_file_body)
      oas_file.rewind
      Linters::CrunchApi::Fetch.new(file: oas_file).lint_to_json
    end

  end

  def ruleset_params
    params.permit(:oas_file)
  end

  def clear_errors
    flash[:error] = nil
  end
end
