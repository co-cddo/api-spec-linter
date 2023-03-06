# frozen_string_literal: true
require "rest-client"

describe Linters::CrunchApi::ReportRetriever do
  let(:rest_client) { class_spy(RestClient, get: "test_report") }
  let(:crunch_base_url) { ENV["CRUNCH_BASE_URL"] }
  let(:api_id) { "123" }
  let(:api_key) { ENV["CRUNCH_API_KEY"] }

  describe "#retrieve_report_for_api" do
    let(:url) { "#{crunch_base_url}/api/v1/apis/#{api_id}/assessmentreport" }
    let(:response) { double("response") }

    context "when the crunch API returns a 200" do
      it "returns the response from the API" do
        report_retriever = described_class.new(rest_client:, base_url: crunch_base_url)

        expect(report_retriever.retrieve_report_for_api(api_id)).to eq("test_report")
        expect(rest_client).to have_received(:get).with(url, { "X-API-KEY": api_key })
      end
    end
  end
end
