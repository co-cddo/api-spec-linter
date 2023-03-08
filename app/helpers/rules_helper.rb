# frozen_string_literal: true

module RulesHelper
  require "govspeak"
  
  def govspeak_to_html(govspeak)
    return if govspeak.blank?

    doc = Govspeak::Document.new govspeak
    doc.to_html.html_safe
  end

  def link_to_rule(label, code)
    url = if I18n.exists?("rules.#{code}")
      rule_path(code)
    else
      [ENV["REMOTE_RULE_LIST_URL"],code].join("#")
    end
    link_to label, url
  end
end
