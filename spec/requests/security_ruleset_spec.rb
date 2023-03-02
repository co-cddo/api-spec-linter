require "rails_helper"

RSpec.describe SecurityRulesetsController, type: :request do
  describe "POST #create" do
    context "when a valid file is uploaded" do
      let(:file) { fixture_file_upload("land-registry.json", "application/json") }

      it "parses the spectral results and renders the show template" do
        allow(Open3).to receive(:capture3).and_return({ "key" => "value" }.to_json, "", double(success?: true))
        post uploads_path, params: { oas_file: file }

        VCR.use_cassette("crunch_api", match_requests_on: %i[host path]) do
          get "/security_ruleset/"
          expect(assigns(:issues)).to_not be_empty
          expect(response).to render_template("show")
        end
      end
    end
  end
end
