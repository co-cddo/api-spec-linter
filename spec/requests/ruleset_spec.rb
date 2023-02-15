# frozen_string_literal: true

require "rails_helper"

describe "RulesetController", type: :request do
  describe "POST /ruleset" do
    it "redirects to the security ruleset form" do
      post ruleset_index_path(ruleset_name: "security_ruleset")

      expect(response).to redirect_to(new_security_ruleset_path)
    end

    it "redirects to the government ruleset form" do
      post ruleset_index_path(ruleset_name: "government_ruleset")

      expect(response).to redirect_to(new_government_ruleset_path)
    end
  end
end
