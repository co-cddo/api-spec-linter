require "rails_helper"

RSpec.describe Linters::CrunchApi::Fetch do
  describe "#lint_to_json" do
    let(:file) { double("file") }
    let(:api_creator) { spy("api_creator", create_api_for_file: "api_id") }
    let(:report_retriever) do
      spy("report_retriever", retrieve_report_for_api: { data: Base64.encode64("test data") }.to_json)
    end
    let(:deleter) { spy("deleter", delete_api: "ok") }
    let(:subject) { described_class.new(api_creator:, report_retriever:, deleter:, file:) }

    before do
      allow(File).to receive(:read).and_return('{ "fake_json_key": "fake_json_value"}')
    end

    context "when an API is created and a report is retrieved" do
      it "creates an API and retrieves the report" do
        described_class.new(api_creator:, report_retriever:, deleter:, file:)

        expect(subject.lint_to_json).to eq("test data")
        expect(api_creator).to have_received(:create_api_for_file).with(file)
        expect(report_retriever).to have_received(:retrieve_report_for_api).with("api_id")
        expect(deleter).to have_received(:delete_api).with("api_id")
      end
    end
  end
end
