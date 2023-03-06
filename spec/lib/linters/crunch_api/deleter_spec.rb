# frozen_string_literal: true
require "rest-client"
require "rails_helper"

describe Linters::CrunchApi::Deleter do
  let(:rest_client) { class_spy(RestClient, delete: "test_report") }
  let(:crunch_base_url) { "https://api.crunch.com" }
  let(:api_id) { "123" }
  let(:api_key) { "api_key" }

  describe "#delete_api" do
    let(:url) { "#{crunch_base_url}/api/v1/apis/#{api_id}" }
    let(:response) { double("response") }

    before do
      stub_const("Linters::CrunchApi::CRUNCH_BASE_URL", crunch_base_url)
      stub_const("Linters::CrunchApi::CRUNCH_API_KEY", api_key)
    end

    context "when the crunch API returns a 200" do
      it "returns the response from the API" do
        deleter = described_class.new(rest_client:, base_url: crunch_base_url)

        expect(deleter.delete_api(api_id)).to eq("test_report")
        expect(rest_client).to have_received(:delete).with(url, { "X-API-KEY": api_key })
      end
    end
  end
end
