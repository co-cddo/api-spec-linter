require 'rails_helper'

describe Linters::Spectral do
  let(:file) { instance_double(File, path: '/tmp/file.txt') }
  let(:system) { class_spy(Open3) }
  subject { described_class.new(file:, system: system) }

  context 'when the file is a valid json file' do
    it 'executes the spectral lint command' do
      expect(system).to receive(:capture3).with("npx spectral lint -f json /tmp/file.txt").and_return("{}")
      output = subject.lint_to_json
      expect(output).to eq("{}")
      expect(file).to have_received(:path)
    end
  end

  context 'When the command fails' do
    it 'raises an error' do
      expect(system).to receive(:capture3).with("npx spectral lint -f json /tmp/file.txt").and_raise(Linters::SpectralLinterError)
      expect { subject.lint_to_json }.to raise_error(Linters::SpectralLinterError)
    end
  end
end
