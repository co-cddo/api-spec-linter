require 'rest-client'
require 'retries'
require 'base64'
module Linters

  module CrunchApi
    CRUNCH_BASE_URL = ENV.fetch('CRUNCH_BASE_URL', 'https://platform.42crunch.com')
    CRUNCH_API_KEY = ENV['CRUNCH_API_KEY']

    class Fetch
      def initialize(api_creator: ApiCreator.new, report_retriever: ReportRetriever.new, file:)
        @api_creator = api_creator
        @report_retriever = report_retriever
        @file = file
      end

      def lint_to_json
        created_api_id = api_creator.create_api_for_file(@file)
        report_response = report_retriever.retrieve_report_for_api(created_api_id)
        Base64.decode64(JSON.parse(report_response)["data"])
      end

      private

      attr_reader :api_creator, :report_retriever
    end
  end

end
