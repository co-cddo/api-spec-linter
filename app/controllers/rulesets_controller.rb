# frozen_string_literal: true

# TODO: Separate this out into a controller per ruleset
class RulesetsController < ApplicationController
  before_action :set_ruleset_name, only: %i[create]
  before_action :clear_errors

  def index
  end

  def create
    redirect_to "/#{@ruleset_name}/new"
  end


  private

  def set_ruleset_name
    @ruleset_name = ruleset_params[:ruleset_name]
  end

  def ruleset_params
    params.permit(:ruleset_name)
  end

  def clear_errors
    flash[:error] = nil
  end

end
