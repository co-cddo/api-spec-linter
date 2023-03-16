require "rails_helper"

describe Linters::Spectral do
  let(:upload) { Upload.new }
  let(:ruleset_name) { "test_ruleset" }
  let(:ruleset_path) { "data/rulesets/#{ruleset_name}.yaml" }
  let(:file_path) { ActiveStorage::Blob.service.path_for(upload.oas_file.key) }
  let(:system_command) { class_spy(PTY) }
  let(:command) { "npx spectral lint -f json #{file_path} --ruleset #{ruleset_path}" }
  subject { described_class.new(upload:, ruleset_name:, system_command:) }

  before do
    upload.oas_file.attach(io: File.open("spec/fixtures/files/valid_file.json"), filename: "valid_openapi.json")
  end

  context "When the command successfully runs" do
    it "executes the spectral lint command" do
      expect(system_command).to receive(:spawn).with(command) do |&block|
        block.call(StringIO.new("{}"), StringIO.new, 12_345)
      end

      output = subject.lint_to_json
      expect(output).to eq("{}")
    end
  end

  context "When the command fails" do
    it "raises an error" do
      expect(system_command).to(
        receive(:spawn)
          .with("npx spectral lint -f json #{file_path} --ruleset #{ruleset_path}")
          .and_raise(StandardError)
      )
      expect { subject.lint_to_json }.to raise_error(StandardError)
    end
  end
end
