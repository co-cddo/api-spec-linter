require "rails_helper"

RSpec.describe GovernmentRulesetsController, type: :request do
  describe "GET #show" do
    let(:file) { fixture_file_upload("land-registry.json", "application/json") }

    it "renders the show template" do
      post uploads_path, params: { oas_file: file }
      get government_ruleset_path

      expect(response).to render_template("show")
    end
  end
end
