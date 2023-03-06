# frozen_string_literal: true
module Linters
  module CrunchApi
    CRUNCH_BASE_URL = ENV.fetch("CRUNCH_BASE_URL", "https://platform.us.42crunch.cloud")
    CRUNCH_API_KEY = ENV["CRUNCH_API_KEY"]
  end
end
