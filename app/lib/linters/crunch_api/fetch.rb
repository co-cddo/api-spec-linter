# frozen_string_literal: true
require 'rest-client'
require 'retries'
require 'base64'
module Linters

  module CrunchApi
    # A class for fetching a crunch 42 report and returning it as a Hash
    class Fetch
      def initialize(file:, api_creator: IdCreator.new, report_retriever: ReportRetriever.new)
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
