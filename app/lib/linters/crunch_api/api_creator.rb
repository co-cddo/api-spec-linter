module Linters
  module CrunchApi
    class ApiCreator
      COLLECTION_ID = ENV['COLLECTION_ID']

      def initialize(rest_client: RestClient, base_url: CRUNCH_BASE_URL)
        @rest_client = rest_client
        @base_url = base_url
      end

      def create_api_for_file(file)
        response = rest_client.post(
          URI.join(base_url, "/api/v1/apis").to_s,
          {
            cid: COLLECTION_ID,
            name: File.basename(file.path, ".*"),
            yaml: false,
            specfile: file
          },
          {
            'X-API-KEY': CRUNCH_API_KEY
          }
        )
        JSON.parse(response).dig("desc", "id")
      end

      private

      attr_reader :rest_client, :base_url
    end
  end
end
