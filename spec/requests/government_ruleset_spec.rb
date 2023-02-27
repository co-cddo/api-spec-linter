require 'rails_helper'

RSpec.describe GovernmentRulesetsController, type: :request do
  describe "GET #show" do
    it "renders the show template" do
      get government_ruleset_path
      expect(response).to render_template("show")
    end
  end
end
