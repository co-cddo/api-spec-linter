module Linters
  class Spectral
    def initialize(file:)
      @file = file
    end

    def lint_to_json
      `spectral lint -f json "#{file.path}"`
    end

    private

    attr_reader :file
  end
end