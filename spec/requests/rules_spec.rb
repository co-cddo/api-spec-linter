require 'rails_helper'

RSpec.describe "Rules", type: :request do

  describe "GET rules/:id" do
    let(:rule) { 'oas3-strict' }
    let(:translation) { I18n.t("rules.#{rule}") }
    let(:output) do
      doc = Govspeak::Document.new(translation)
      doc.to_html.html_safe
    end

    it "returns http success" do
      get rule_path(rule)
      expect(response).to have_http_status(:success)
    end

    it "outputs the matching translation as markdown" do
      get rule_path(rule)
      expect(response.body).to include(output)
    end
  end

  describe "GET rules/" do
    it "returns http success" do
      get rules_path
      expect(response).to have_http_status(:success)
    end

    it "lists the rules" do
      get rules_path
      expect(response.body).to include(RuleText.rules.values.first)
    end
  end
end
