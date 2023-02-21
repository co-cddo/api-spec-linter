module Linters
  module CrunchApi
    class ReportRetriever
      def initialize(rest_client: RestClient, base_url: CRUNCH_BASE_URL)
        @rest_client = rest_client
        @base_url = base_url
      end

      def retrieve_report_for_api(api_id)
        url = URI.join(base_url, "/api/v1/apis/", "#{api_id}/", "assessmentreport").to_s
        rest_client.get(url,
          {
            'X-API-KEY': CRUNCH_API_KEY
          }
        )
      end

      private

      attr_reader :rest_client, :base_url
    end

  end
end
