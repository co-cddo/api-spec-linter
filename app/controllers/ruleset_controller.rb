# frozen_string_literal: true

# TODO: Separate this out into a controller per ruleset
class RulesetController < ApplicationController
  before_action :set_ruleset_name, only: %i[new create]
  before_action :clear_errors

  def new
    if @ruleset_name == 'government_ruleset'
      return redirect_to '/government_ruleset/new'
    end

    render @ruleset_name
  end

  def create

    # If no ruleset has been specified (someone has bypassed it somehow)
    # redirect to the home page
    if @ruleset_name.nil?
      redirect_to root_path
      return
    end

    # If a file hasn't been uploaded yet, ask for one.
    if ruleset_params[:oas_file].nil?
      flash[:error] = "Please upload a file"
      return render @ruleset_name
    end

    # If it is not a valid JSON file, ask again.
    if ruleset_params[:oas_file].content_type != "application/json"
      flash[:error] = "This is not a valid JSON file"
      return render @ruleset_name
    end

    if @ruleset_name == 'security_ruleset' # Call 42Crunch service
      if ENV['BYPASS_API'] == 'true'
        crunch_results = File.read('fakecrunchresults.json')
      else
        crunch_results = Linters::CrunchApi.new(file: ruleset_params[:oas_file]).lint_to_json
      end
      crunch_json = JSON.parse(crunch_results)
      @score = crunch_json['score']
      @openapi = crunch_json['openapiState']
      @counter = crunch_json['issueCounter']
      @criticality = crunch_json['criticality']
      @issues = Array.new
      crunch_json['data']['issues'].each do |issue|
        lines = Array.new
        issue[1]['issues'].each do | occurrence|
          lines.push(occurrence['pointer'])
        end
        @issues.push([issue[1]['criticality'],issue[1]['description'], lines])
      end
    elsif @ruleset_name == 'government_ruleset' # Call Spectral service
      @spectral_results = JSON.parse(Linters::Spectral.new(file: ruleset_params[:oas_file]).lint_to_json)
    end

    render @ruleset_name
  end

  private

  def set_ruleset_name
    @ruleset_name = ruleset_params[:ruleset_name]
  end

  def ruleset_params
    params.permit(:oas_file, :ruleset_name)
  end

  def clear_errors
    flash[:error] = nil
  end

end
