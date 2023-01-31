# frozen_string_literal: true

require "rails_helper"

describe "RulesetController", type: :request do
  describe "GET /ruleset/new" do
    it "renders a page with a form for the security ruleset" do
      get new_ruleset_path(which_ruleset: "security_ruleset")

      expect(response).to render_template(RulesetController::SECURITY_RULESET)
    end

    it "renders a page with a form for the government ruleset" do
      get new_ruleset_path(which_ruleset: "government_ruleset")

      expect(response).to render_template("government_ruleset")
    end
  end

  describe "POST /ruleset" do
    it "returns a 200" do
      post("/ruleset", params: { which_ruleset: "security_ruleset" })

      expect(response).to have_http_status(:ok)
    end
  end
end
