# frozen_string_literal: true
# pty is a library that can help mitigate output buffering issues where as Open3 cuts off the stdout stream if
# it is too long

module Linters
  class Spectral

    def initialize(upload:, ruleset_name:, system_command: Open3)
      @upload = upload
      @ruleset_name = ruleset_name
      @system_command = system_command
    end

    def lint_to_json
      path = ActiveStorage::Blob.service.path_for(upload.oas_file.key)
      command = "npx spectral lint -f json #{path} --ruleset data/rulesets/#{ruleset_name}.yaml"
      stdout_str, stderr_str, status = "", "", nil

      Tempfile.open('spectral_output') do |tempfile|
        process_id = spawn(command, out: tempfile.path, err: tempfile.path)

        _, status = Process.wait2(process_id)

        stdout_str = File.read(tempfile.path)
      end

      stdout_str
    rescue StandardError => e
      Rails.logger.error("npx spectral command failed: #{stderr_str}")
      raise "npx spectral command failed: #{e.message}"
    end


    private

    attr_reader :upload, :system_command, :ruleset_name
  end
end
