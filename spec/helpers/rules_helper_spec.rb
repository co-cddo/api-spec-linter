require 'rails_helper'

RSpec.describe RulesHelper, type: :helper do
  describe "#govspeak_to_html" do
    it "renders the markdown" do
      expect(helper.govspeak_to_html("Hello")).to eq("<p>Hello</p>\n")
    end
  end

  describe "link_to_rule" do
    let(:rule) { "oas3-strict" }

    it "returns a link to the matching rule" do
      expect(helper.link_to_rule("Rule", rule)).to include(rule_path(rule))
    end

    it "includes the label in the link" do
      expect(helper.link_to_rule("Rule", rule)).to include("Rule")
    end

    context "with a rule that is not locally defined" do
      let(:rule) { "undefined" }
      let(:remote_url) { ENV["REMOTE_RULE_LIST_URL"] }

      it "returns a link to the matching page on remote site" do
        expect(helper.link_to_rule("Rule", rule)).to include("#{remote_url}##{rule}")
      end

      it "includes the label in the link" do
        expect(helper.link_to_rule("Rule", rule)).to include("Rule")
      end
    end

  end
end
