# frozen_string_literal: true
class RulesController < ApplicationController
  def index
    @rules = RuleText.rules
  end

  def show
    @rule_name = params[:id]
  end
end
