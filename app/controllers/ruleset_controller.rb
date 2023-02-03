# frozen_string_literal: true

# TODO: Separate this out into a controller per ruleset
class RulesetController < ApplicationController
  before_action :set_ruleset_type, only: %i[new create]

  def new
    render @ruleset_name
  end

  def create
    if ruleset_params[:oas_file].nil?
      flash[:error] = "Please upload a file"
      return render @ruleset_name
    end

    # Here we can call our 42 crunch or spectral service
    if @ruleset_name == 'government_ruleset'
      linter_output = Linters::Spectral.new(file: ruleset_params[:oas_file]).lint_to_json
      render(json: linter_output)
    end

    begin
      crunch = Linters::CrunchApi.new
      file = ruleset_params[:oas_file].tempfile
      @crunch_results = crunch.lint(file)
    rescue StandardError => e
      puts e.message
      # TODO: We don't want to reveal the full 42Crunch error message
      # but we might for example give the user a reference number here
      # so that we can find the full error in the logs.
      flash[:error] = "Unable to run linter on the uploaded file"
      return render @ruleset_name
    end

    render @ruleset_name

  end

  private

  def set_ruleset_type
    @ruleset_name = ruleset_params[:which_ruleset]
  end

  def ruleset_params
    params.permit(:oas_file, :which_ruleset)
  end
end
