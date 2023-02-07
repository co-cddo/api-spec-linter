module Linters
  class SpectralLinterError < StandardError; end
  class Spectral

    def initialize(file:)
      @file = file
    end

    def lint_to_json
      stdout_str, stderr_str = Open3.capture3("npx spectral lint -f json #{file.path}")
      raise_error(stderr_str) if stderr_str.present?

      stdout_str
    end

    private

    attr_reader :file

    def raise_error(error_message)
      Rails.logger.error("npx spectral command failed: #{error_message}")

      raise SpectralLinterError, "npx spectral command failed"
    end
  end
end
