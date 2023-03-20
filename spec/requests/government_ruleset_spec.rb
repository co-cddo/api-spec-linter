require "rails_helper"

RSpec.describe GovernmentRulesetsController, type: :request do
  describe "GET #show" do
    let(:file_upload) { fixture_file_upload("land-registry.json", "application/json") }
    let(:tempfile) { instance_double(Tempfile, read: "{}", path: "test_path/") }


    it "renders the show template" do
      allow(Kernel).to receive(:spawn).with(any_args).and_return(12_345)
      expect(Process).to receive(:wait2).with(12_345).and_return([12_345, double("status", exited?: true)])
      expect(Tempfile).to receive(:open).with("spectral_output").and_yield(tempfile)

      post uploads_path, params: { oas_file: file_upload }
      get government_ruleset_path(ruleset_name: "ruleset_low")

      expect(response).to render_template("show")
    end
  end
end
