require 'rest-client'
require 'base64'
module Linters

  # A class called Crunch
  class CrunchApi

    def initialize(file:, base_url: "https://platform.42crunch.com")
      @file = file
      @base_url = base_url
    end

    # Lints an unploaded file with 42crunch.
    #
    # @param file [File] the file to be linted
    # @return [String] the raw JSON response
    def lint_to_json

      # Post the file to 42Crunch according to their API v1 "Create an API (from file)" spec
      # https://www.postman.com/get-42crunch/workspace/42crunch-api/request/13761657-335bcb36-c68f-43a1-823d-741b62b55bc6
      begin
        create_response = RestClient.post( @base_url + "/api/v1/apis",
        { # Body of the request
          cid: ENV['COLLECTION_ID'], # Collection id, returned by "Create a collection"
          name: File.basename(@file.path, ".*"), # API Display Name
          yaml: false, # Set to true if the specification file was converted to JSON from YAML
          specfile: @file # Raw OAS file in JSON format - YAML is not supported
        },
        { # Request headers
        'X-API-KEY': ENV['CRUNCH_API_KEY']
        })
      rescue RestClient::MovedPermanently,
             RestClient::Found,
             RestClient::TemporaryRedirect => err
        err.response.follow_redirection
      rescue RestClient::Unauthorized, RestClient::Forbidden => err
        raise 'Access denied by 42Crunch API'
      rescue RestClient::RequestFailed => err
        raise '42Crunch Create Request Failed'
      end

      # Parse the JSON response to get the ID needed to get the linting results
      # (which requires a second API call)
      begin
        created_api_id = JSON.parse(create_response)["desc"]["id"]
      rescue JSON::ParserError
        raise "Couldn't parse JSON response from 42Crunch Create API V1"
      end

      # Use the created API ID to get the linting results from 42Crunch using their
      # API V1 "Retrieve and visualize a security audit report" spec
      # https://www.postman.com/get-42crunch/workspace/42crunch-api/request/13761657-85a4551d-8350-4744-ba62-e4289103ec81
      begin
        report_response = RestClient.get(@base_url + "/api/v1/apis/" + created_api_id + "/assessmentreport",
        { # Request headers
        'X-API-KEY': ENV['CRUNCH_API_KEY']
        })
      rescue RestClient::MovedPermanently,
             RestClient::Found,
             RestClient::TemporaryRedirect => err
        err.response.follow_redirection
      rescue RestClient::Unauthorized, RestClient::Forbidden => err
        raise 'Access denied by 42Crunch API'
      rescue RestClient::RequestFailed => err
        raise '42Crunch Retrieve Report Request Failed'
      end


      # Parse the JSON response to get the report data
      begin
        report_data = JSON.parse(report_response)["data"]
      rescue JSON::ParserError
        raise "Couldn't parse JSON response from 42Crunch Retrieve Report API V1"
      end

      begin
        decoded_report_data = Base64.decode64(report_data)
      rescue Base64::Error
        raise "Couldn't decode data from 42Crunch Retrieve Report API V1"
      end


      return decoded_report_data

    end

  end

end
