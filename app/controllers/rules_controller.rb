# frozen_string_literal: true
class RulesController < ApplicationController
  def show
    @rule_name = params[:id]
  end
end
