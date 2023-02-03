module Linters
  class Spectral

    def initialize(file:)
      @file = file
    end

    def lint_to_json
      # Use npx to run spectral-cli from the npm modules directory
      # without it needed to be installed globally
        `npx spectral lint -f json "#{file.path}"`
    end

    private

    attr_reader :file
  end
end
