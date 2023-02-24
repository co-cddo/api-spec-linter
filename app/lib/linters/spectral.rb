# frozen_string_literal: true
module Linters
  class SpectralLinterError < StandardError; end
  class Spectral

    def initialize(file:, system_command: Open3)
      @file = file
      @system_command = system_command
    end

    def lint_to_json
      stdout_str, stderr_str = system_command.capture3("npx spectral lint -f json #{file.path}")
      raise SpectralLinterError stderr_str if stderr_str.present?
      stdout_str
    rescue StandardError => e
      Rails.logger.error("npx spectral command failed: #{stderr_str}")
      Rails.logger.error(stdout_str)
      raise SpectralLinterError, "npx spectral command failed: #{e.message}"
    end

    private

    attr_reader :file, :system_command
  end
end
