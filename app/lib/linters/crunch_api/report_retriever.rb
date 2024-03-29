# frozen_string_literal: true
module Linters
  module CrunchApi
    # Use the created API ID to get the linting results from 42Crunch using their
    # API V1 "Retrieve and visualize a security audit report" spec
    class ReportRetriever
      def initialize(rest_client: RestClient, base_url: CRUNCH_BASE_URL)
        @rest_client = rest_client
        @base_url = base_url
      end

      def retrieve_report_for_api(api_id)
        url = URI.join(base_url, "/api/v1/apis/", "#{api_id}/", "assessmentreport").to_s
        rest_client.get(url, { "X-API-KEY": CRUNCH_API_KEY })
      end

      private

      attr_reader :rest_client, :base_url
    end
  end
end
