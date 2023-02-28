require "spec_helper"

RSpec.describe Linters::CrunchApi::IdCreator do
  describe "#create_api_for_file" do
    let(:rest_client) { class_spy(RestClient, post: { desc: { id: "api123" } }.to_json) }
    let(:file) { File.new("spec/fixtures/files/valid_file.json") }
    let(:collection_id) { "collection_id" }
    let(:api_key) { "api_key" }
    let(:crunch_base_url) { "https://api.crunch.com" }

    before do
      stub_const("Linters::CrunchApi::IdCreator::COLLECTION_ID", collection_id)
      stub_const("Linters::CrunchApi::CRUNCH_BASE_URL", crunch_base_url)
      stub_const("Linters::CrunchApi::CRUNCH_API_KEY", api_key)
    end

    subject { described_class.new(rest_client:, base_url: crunch_base_url) }

    context "when crunch returns a 200" do
      it "posts the file to the 42Crunch API and returns the ID of the created API" do
        api_id = subject.create_api_for_file(file)

        expect(rest_client).to have_received(:post).with(
          "#{crunch_base_url}/api/v1/apis",
          { cid: collection_id, name: "valid_file", yaml: false, specfile: file },
          { "X-API-KEY": api_key }
        )
        expect(api_id).to eq("api123")
      end
    end
  end
end
