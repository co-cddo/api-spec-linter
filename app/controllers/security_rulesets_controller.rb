
class SecurityRulesetsController < ApplicationController
  include RulesetValidations

  before_action :validate_file_upload!, only: [:create]
  before_action :clear_errors

  def new
  end

  def create
    crunch_hash = JSON.parse(crunch42_data)
    @score = crunch_hash['score']
    @openapi = crunch_hash['openapiState']
    @counter = crunch_hash['issueCounter']
    @criticality = crunch_hash['criticality']
    @issues = crunch_hash['data']['issues'].map do |_key, issue|
      lines = issue['issues'].pluck('pointer')
      [issue['criticality'],issue['description'], lines]
    end

    render 'show'
  end

  private

  def crunch42_data
    return File.read('fakecrunchresults.json') if ENV['BYPASS_API'] == 'true'

    Linters::CrunchApi.new(file: ruleset_params[:oas_file]).lint_to_json
  end

  def ruleset_params
    params.permit(:oas_file)
  end

  def clear_errors
    flash[:error] = nil
  end
end
