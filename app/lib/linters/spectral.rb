# frozen_string_literal: true
# pty is a library that can help mitigate output buffering issues where as Open3 cuts of the stdout stream if
# it is too long
require 'pty'

module Linters
  class Spectral

    def initialize(upload:, ruleset_name:, system_command: PTY)
      @upload = upload
      @ruleset_name = ruleset_name
      @system_command = system_command
    end

    def lint_to_json
      path = ActiveStorage::Blob.service.path_for(upload.oas_file.key)
      command = "npx spectral lint -f json #{path} --ruleset data/rulesets/#{ruleset_name}.yaml"
      stdout_str = ""

      system_command.spawn(command) do |stdout, _stdin, _pid|
        stdout.each do |line|
          stdout_str += line
        end
      end

      stdout_str
    rescue StandardError => e
      Rails.logger.error("Failed to run npx spectral command against file: #{path} with error: #{e.message}")
      raise
    end

    private

    attr_reader :upload, :system_command, :ruleset_name
  end
end
