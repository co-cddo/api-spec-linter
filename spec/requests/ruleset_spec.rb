# frozen_string_literal: true

require "rails_helper"

describe "RulesetController", type: :request do
  describe "POST /ruleset" do
    it "redirects to the security ruleset form" do
      post rulesets_path(ruleset_name: "security_ruleset")

      expect(response).to redirect_to("/security_ruleset/")
    end

    it "redirects to the government ruleset form" do
      post rulesets_path(ruleset_name: "government_ruleset")

      expect(response).to redirect_to("/government_ruleset/")
    end
  end
end
