# frozen_string_literal: true
module RulesetValidations
  extend ActiveSupport::Concern

  private

  def validate_ruleset_name!
    redirect_to root_path if @ruleset_name.nil?
  end
end
