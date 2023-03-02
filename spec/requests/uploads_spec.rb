require "rails_helper"

RSpec.describe UploadsController, type: :request do
  describe "GET #index" do
    it "renders the new template" do
      get uploads_path
      expect(response).to render_template("index")
    end
  end

  describe "POST #create" do
    context "when an invalid file is uploaded" do
      let(:file) { fixture_file_upload("invalid_file.txt", "text/plain") }

      it "returns an error message" do
        post uploads_path, params: { oas_file: file }
        expect(response).to render_template("index")
      end
    end

    context "when no file is uploaded" do
      it "returns an error message" do
        post uploads_path
        expect(response).to render_template("index")
      end
    end
  end
end
