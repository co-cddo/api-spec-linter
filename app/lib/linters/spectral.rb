# frozen_string_literal: true
module Linters
  class SpectralLinterError < StandardError
  end
  class Spectral
    def initialize(upload:, ruleset_name:, system_command: Open3)
      @upload = upload
      @ruleset_name = ruleset_name
      @system_command = system_command
    end

    def lint_to_json
      binding.pry
      path = ActiveStorage::Blob.service.path_for(upload.oas_file.key)
      # We can get rid of this once we use the database and active storage to store the file
      stdout_str, stderr_str = system_command.capture3("npx spectral lint -f json #{path} --ruleset data/rulesets/#{ruleset_name}")
      raise ::Linters::SpectralLinterError stderr_str if stderr_str.present?
      stdout_str
    rescue StandardError => e
      binding.pry
      Rails.logger.error("npx spectral command failed: #{stderr_str}")
      Rails.logger.error(stdout_str)
      raise ::Linters::SpectralLinterError, "npx spectral command failed: #{e.message}"
    end

    private

    attr_reader :upload, :system_command, :ruleset_name
  end
end
