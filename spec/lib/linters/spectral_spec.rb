require 'rails_helper'

describe Linters::Spectral do
  let(:file) { instance_double(File, path: '/tmp/file.txt') }
  subject { described_class.new(file:) }

  it 'executes the spectral lint command' do
    expect(subject).to receive(:`).with("npx spectral lint -f json \"/tmp/file.txt\"").and_return("{}")
    output = subject.lint_to_json
    expect(output).to eq("{}")
    expect(file).to have_received(:path)
  end
end
