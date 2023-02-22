module Linters
  module CrunchApi
    CRUNCH_BASE_URL = ENV.fetch('CRUNCH_BASE_URL', 'https://platform.42crunch.com')
    CRUNCH_API_KEY = ENV['CRUNCH_API_KEY']
  end
end
