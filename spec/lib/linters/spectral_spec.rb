require 'rails_helper'

describe Linters::Spectral do
  let(:file) { instance_double(File, path: '/tmp/file.json') }
  let(:system_command) { class_spy(Open3) }
  subject { described_class.new(file: file, system_command: system_command) }

  context 'When the command successfully runs' do
    it 'executes the spectral lint command' do
      expect(system_command).to receive(:capture3).with("npx spectral lint -f json /tmp/file.json").and_return(['{}', ''])
      output = subject.lint_to_json
      expect(output).to eq("{}")
      expect(file).to have_received(:path)
    end
  end

  context 'When the command fails' do
    it 'raises an error' do
      expect(system_command).to(
        receive(:capture3)
        .with("npx spectral lint -f json /tmp/file.json")
        .and_raise(Linters::SpectralLinterError))
      expect { subject.lint_to_json }.to raise_error(Linters::SpectralLinterError)
    end
  end
end
