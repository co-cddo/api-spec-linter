# frozen_string_literal: true

module Linters
  # In this class we output the spectral output to a tempfile to get around buffering issues when returning output
  # from the npx command
  class Spectral

    def initialize(upload:, ruleset_name:, system_command: Kernel)
      @upload = upload
      @ruleset_name = ruleset_name
      @system_command = system_command
    end

    def lint_to_json
      path = ActiveStorage::Blob.service.path_for(upload.oas_file.key)
      command = "npx spectral lint -f json #{path} --ruleset data/rulesets/#{ruleset_name}.yaml"
      stdout_str = ""
      status = nil

      Tempfile.open('spectral_output') do |tempfile|
        process_id = system_command.spawn(command, out: tempfile.path, err: tempfile.path)

        _, status = Process.wait2(process_id)

        raise unless status.exited?

        stdout_str = tempfile.read
      end

      stdout_str
    rescue StandardError => e
      Rails.logger.error("npx spectral command failed: #{command}")
      raise "npx spectral command failed: #{e.message}"
    end


    private

    attr_reader :upload, :system_command, :ruleset_name
  end
end
