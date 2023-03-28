# frozen_string_literal: true
class RuleText
  RULE_LOCATION = [:en, :rules].freeze

  def self.rules
    @rules ||= begin
      I18n.t('foo') # Do a lookup to ensure I18n backend is populated
      rules = I18n.config.backend.translations.dig(*RULE_LOCATION)
      rules.transform_values {|rule| rule.split("\n").first}
    end
  end
end
