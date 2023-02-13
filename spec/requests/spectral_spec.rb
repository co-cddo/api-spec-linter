require 'rails_helper'

RSpec.describe SpectralController, type: :controller do
  describe "GET #new" do
    it "renders the government_ruleset template" do
      get :new
      expect(response).to render_template("government_ruleset")
    end
  end

  describe "POST #create" do
    context "when an invalid file is uploaded" do
      let(:file) { fixture_file_upload("invalid_file.txt", "text/plain") }

      it "returns an error message" do
        post :create, params: { oas_file: file }
        expect(flash[:error]).to eq("This is not a valid JSON file")
        expect(response).to render_template("government_ruleset")
      end
    end

    context "when no file is uploaded" do
      it "returns an error message" do
        post :create
        expect(flash[:error]).to eq("Please upload a file")
        expect(response).to render_template("government_ruleset")
      end
    end

    context "when a valid file is uploaded" do
      let(:file) { fixture_file_upload("valid_file.json", "application/json") }

      it "parses the spectral results and renders the government_ruleset template" do
        allow(Linters::Spectral).to receive(:new).and_return(double(lint_to_json: '{ "key": "value" }'))

        post :create, params: { oas_file: file }
        expect(assigns(:spectral_results)).to eq({ "key" => "value" })
        expect(response).to render_template("government_ruleset")
      end
    end
  end
end
