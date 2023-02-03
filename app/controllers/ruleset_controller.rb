# frozen_string_literal: true

# TODO: Separate this out into a controller per ruleset
class RulesetController < ApplicationController
  before_action :set_ruleset_type, only: %i[new create]
  before_action :clear_errors

  def new
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

    # Make the API calls in a begin/rescue block so that
    # we don't crash out if the API or CLI calls fail.
    begin
      if @ruleset_name == 'security_ruleset' # Call 42Crunch service
        @crunch_results = Linters::CrunchApi.new.lint_to_json(ruleset_params[:oas_file].tempfile)
      elsif @ruleset_name == 'government_ruleset' # Call Spectral service
        @spectral_results = Linters::Spectral.new(file: ruleset_params[:oas_file]).lint_to_json
      end
    rescue StandardError => e
      puts e.message
      # TODO: We don't want to reveal the full 42Crunch or Spectral error message
      # to the user but we might for example give the user a reference number here
      # so that we can find the full error in the logs.
      #flash[:error] = "Unable to run linter on the uploaded file"
      flash[:error] = e.message
    end

    # Render a view based on which ruleset was selected
    return render @ruleset_name

  end

  private

  def set_ruleset_type
    @ruleset_name = ruleset_params[:which_ruleset]
  end

  def ruleset_params
    params.permit(:oas_file, :which_ruleset)
  end

  def clear_errors
    flash[:error] = nil
  end

end
