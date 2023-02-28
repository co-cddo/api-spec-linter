# frozen_string_literal: true
module Linters
  class SpectralLinterError < StandardError
  end
  class Spectral
    def initialize(file_name:, file_body:, system_command: Open3)
      @file_name = file_name
      @file_body = file_body
      @system_command = system_command
    end

    def lint_to_json
      Tempfile.open(@file_name) do |oas_file|
        oas_file.write(@file_body)
        oas_file.rewind
        stdout_str, stderr_str = system_command.capture3("npx spectral lint -f json #{oas_file.path}")
        raise SpectralLinterError stderr_str if stderr_str.present?
        stdout_str
      rescue StandardError => e
        Rails.logger.error("npx spectral command failed: #{stderr_str}")
        Rails.logger.error(stdout_str)
        raise SpectralLinterError, "npx spectral command failed: #{e.message}"
      end
    end

    private

    attr_reader :file_name, :file_body, :system_command
  end
end
