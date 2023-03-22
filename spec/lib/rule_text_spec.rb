require 'rails_helper'

RSpec.describe RuleText do
  let(:locale) { YAML.load_file(Rails.root.join('config/locales/rules.yml')) }

  describe '.rules' do
    subject(:rules) { described_class.rules }

    it 'is a hash' do
      expect(rules).to be_a(Hash)
    end

    it 'has the keys from the locale file' do
      expect(rules.keys.map(&:to_s)).to contain_exactly(*locale.dig("en", "rules").keys)
    end

    it 'has values which contain the first line of the translation' do
      expect(rules[:'license-url']).to eq('License URL')
    end
  end
end
