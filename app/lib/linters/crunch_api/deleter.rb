# frozen_string_literal: true
module Linters
  module CrunchApi
    # Delete everything from 42Crunch when we are finished using
    # API V1 "Delete an API" spec
    # This makes it much less likely we will hit 42Crunch storage
    # limits (unless huge numbers of people are using it once).
    class Deleter
      def initialize(rest_client: RestClient, base_url: CRUNCH_BASE_URL)
        @rest_client = rest_client
        @base_url = base_url
      end

      def delete_api(api_id)
        url = URI.join(base_url, "/api/v1/apis/", api_id.to_s).to_s
        rest_client.delete(url, { "X-API-KEY": CRUNCH_API_KEY })
      end

      private

      attr_reader :rest_client, :base_url
    end
  end
end
