require "rails_helper"

RSpec.describe UploadsController, type: :request do
  describe "GET #index" do
    it "renders the new template" do
      get new_upload_path
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "when an invalid file is uploaded" do
      let(:upload) { fixture_file_upload("invalid_file.txt", "text/plain") }

      it "returns an error message" do
        post uploads_path, params: { oas_file: upload }
        expect(response).to render_template("new")
        expect(response.body).to include("This is not a valid JSON file")
      end
    end

    context "when no file is uploaded" do
      it "returns an error message" do
        post uploads_path
        expect(response).to render_template("new")
        expect(response.body).to include("No file was selected")
      end
    end
  end
end
