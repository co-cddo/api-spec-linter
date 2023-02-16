require 'rest-client'
require 'retries'
require 'base64'
module Linters

  # A class called Crunch
  class CrunchApi

    CRUNCH_BASE_URL = ENV.fetch('CRUNCH_BASE_URL', 'https://platform.42crunch.com')

    def initialize(file:, base_url: CRUNCH_BASE_URL)
      @file = file
      @base_url = base_url
    end

    # Post the file to 42Crunch according to their API v1 "Create an API (from file)" spec
    # https://www.postman.com/get-42crunch/workspace/42crunch-api/request/13761657-335bcb36-c68f-43a1-823d-741b62b55bc6
    def create_api

      RestClient.post(URI.join(@base_url, "/api/v1/apis").to_s,
      { # Body of the request
        cid: ENV['COLLECTION_ID'], # Collection id, returned by "Create a collection"
        name: File.basename(file.path, ".*"), # API Display Name
        yaml: false, # Set to true if the specification file was converted to JSON from YAML
        specfile: file # Raw OAS file in JSON format - YAML is not supported
      },
      { # Request headers
      'X-API-KEY': ENV['CRUNCH_API_KEY']
      })

    end

    # Use the created API ID to get the linting results from 42Crunch using their
    # API V1 "Retrieve and visualize a security audit report" spec
    # https://www.postman.com/get-42crunch/workspace/42crunch-api/request/13761657-85a4551d-8350-4744-ba62-e4289103ec81
    # @param id [String] the ID of the report to retrieve
    # @return [String] the raw JSON response
    def retrieve_report(id)
      url = URI.join(@base_url, "/api/v1/apis/", "#{id}/", "assessmentreport").to_s
      RestClient.get(url,
      { # Request headers
      'X-API-KEY': ENV['CRUNCH_API_KEY']
      })
    end

    # Lints an unploaded file with 42crunch.
    #
    # @param file [File] the file to be linted
    # @return [String] the raw JSON response
    def lint_to_json

      # Create an API for the file we initialized this class with then
      # parse the JSON response to get the ID needed to get the linting results
      created_api_id = JSON.parse(create_api).dig("desc","id")

      # We need a second request to retrieve the actual report.
      # If we try to get the report too quickly 42crunch will return a 404 error
      # So we need to use exponential backoff from the 'retries' gem
      report_response = ""
      with_retries(max_tries: 10, rescue: [RestClient::RequestFailed]) do
        report_response = retrieve_report(created_api_id)
      end

      # Parse the JSON response to get the report data
      Base64.decode64(JSON.parse(report_response)["data"])

    end


    private

    attr_reader :file

  end

end
