require "rails_helper"

describe Linters::Spectral do
  let(:file_name) { "file.json" }
  let(:file_body) { "{}" }
  let(:system_command) { class_spy(Open3) }
  subject { described_class.new(file_name:, file_body:, system_command:) }

  context "When the command successfully runs" do
    it "executes the spectral lint command" do
      expect_any_instance_of(Tempfile).to receive(:path).and_return("/tmp/file.json")
      expect(system_command).to receive(:capture3).with("npx spectral lint -f json /tmp/file.json").and_return(
        ["{}", ""]
      )
      output = subject.lint_to_json
      expect(output).to eq("{}")
    end
  end

  context "When the command fails" do
    it "raises an error" do
      expect_any_instance_of(Tempfile).to receive(:path).and_return("/tmp/file.json")
      expect(system_command).to(
        receive(:capture3).with("npx spectral lint -f json /tmp/file.json").and_raise(StandardError)
      )
      expect { subject.lint_to_json }.to raise_error(Linters::SpectralLinterError)
    end
  end
end
