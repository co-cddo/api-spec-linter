require "rails_helper"

describe Linters::Spectral do
  let(:upload) { Upload.new }
  let(:system_command) { class_spy(Open3) }
  subject { described_class.new(upload:, system_command:) }

  before do
    upload.oas_file.attach(io: File.open("spec/fixtures/files/valid_file.json"), filename: "valid_openapi.json")
  end

  context "When the command successfully runs" do
    it "executes the spectral lint command" do
      expect(system_command).to receive(:capture3).with("npx spectral lint -f json #{ActiveStorage::Blob.service.path_for(upload.oas_file.key)}").and_return(
        ["{}", ""]
      )
      output = subject.lint_to_json
      expect(output).to eq("{}")
    end
  end

  context "When the command fails" do
    it "raises an error" do
      expect(system_command).to(
        receive(:capture3).with("npx spectral lint -f json #{ActiveStorage::Blob.service.path_for(upload.oas_file.key)}").and_raise(StandardError)
      )
      expect { subject.lint_to_json }.to raise_error(Linters::SpectralLinterError)
    end
  end
end
