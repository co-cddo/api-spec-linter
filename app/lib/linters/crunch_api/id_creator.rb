# frozen_string_literal: true
module Linters
  module CrunchApi

    # Post the file to 42Crunch according to their API v1 "Create an API (from file)" spec
    class IdCreator
      COLLECTION_ID = ENV['COLLECTION_ID']

      def initialize(rest_client: RestClient, base_url: CRUNCH_BASE_URL)
        @rest_client = rest_client
        @base_url = base_url
      end

      def create_api_for_file(file)
        response = rest_client.post(
          URI.join(base_url, "/api/v1/apis").to_s,
          {
            cid: COLLECTION_ID,  # Collection id, returned by "Create a collection"
            name: File.basename(file.path, ".*"), # API Display Name
            yaml: false, # Set to true if the specification file was converted to JSON from YAML
            specfile: file # Raw OAS file in JSON format - YAML is not supported
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
