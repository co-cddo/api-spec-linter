# frozen_string_literal: true
require "rest-client"
require "retries"
require "base64"
module Linters
  module CrunchApi
    # A class for fetching a crunch 42 report and returning it as a Hash
    class Fetch
      def initialize(file:, api_creator: IdCreator.new, report_retriever: ReportRetriever.new, deleter: Deleter.new)
        @api_creator = api_creator
        @report_retriever = report_retriever
        @deleter = deleter
        @file = file
      end

      def lint_to_json
        # If parsing the file as JSON fails, return a report saying the format is wrong
        begin
          JSON.parse(File.read(@file))
        rescue JSON::ParserError
          return bad_json
        end

        # Otherwise call the API to upload the file to 42Crunch and return the ID
        created_api_id = api_creator.create_api_for_file(@file)

        # Use exponential backoff to call the second API function to retrieve the
        # report (This is needed because 42crunch sometimes needs a while to process)
        report_response = ""
        with_retries(max_tries: 10, rescue: [RestClient::RequestFailed]) do
          report_response = report_retriever.retrieve_report_for_api(created_api_id)
        end

        #Delete everything we have created on 42Crunch to avoid hitting service limits
        deleter.delete_api(created_api_id)

        Base64.decode64(JSON.parse(report_response)["data"])
      end

      private

      # A JSON template in the same format as a 42crunch report so we can report
      # a badly formatted JSON file in the same way, but without an API call.
      def bad_json
        {
          score: 0,
          openapiState: "invalid",
          issueCounter: 0,
          criticality: 5,
          data: {
            issues: {
              badJson: {
                description: "The document could not be parsed as JSON.",
                criticality: 5,
                issues: [{ pointer: 0 }]
              }
            }
          }
        }.to_json
      end

      attr_reader :api_creator, :report_retriever, :deleter
    end
  end
end
