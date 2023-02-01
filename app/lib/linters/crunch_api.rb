require 'rest-client'

module Linters

  # A class called Crunch
  class CrunchApi

    attr_accessor :base_url

    def initialize()
      @base_url = "https://platform.42crunch.com"
    end

    def lint(filename)

      response = "API Response: "

      begin
        response += RestClient.post( @base_url << "/api/v1/apis",
        { # Body of the request
          :cid => ENV['COLLECTION_ID'],
          :name => filename,
          :yaml => false,
          :specfile => File.new(filename, 'rb')
        },
        { # Request headers
        'X-API-KEY': ENV['CRUNCH_API_KEY']
        })
      rescue RestClient::MovedPermanently,
             RestClient::Found,
             RestClient::TemporaryRedirect => err
        err.response.follow_redirection
      rescue RestClient::Unauthorized, RestClient::Forbidden => err
        puts 'Access denied'
        return err.response
      rescue RestClient::RequestFailed => err
        puts 'API Request Failed'
        return err.response
      end

      return response

    end

  end

end
