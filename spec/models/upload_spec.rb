# == Schema Information
#
# Table name: uploads
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Upload, type: :model do
  subject { described_class.new }

  describe 'validations' do
    let(:valid_file_path) { Rails.root.join('spec/fixtures/files/valid_file.json') }
    let(:invalid_file_path) { Rails.root.join('spec/fixtures/files/invalid_file.txt') }

    before do
      subject.oas_file.attach(io: File.open(valid_file_path), filename: 'valid_file.json')
    end

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without a file' do
      subject.oas_file.detach
      expect(subject).to be_invalid
      expect(subject.errors[:oas_file]).to include("No file was selected")
    end

    it 'is invalid with a file that has an invalid content type' do
      subject.oas_file.attach(io: File.open(invalid_file_path), filename: 'invalid_file.txt')
      expect(subject).to be_invalid
      expect(subject.errors[:oas_file]).to include("This is not a valid JSON file")
    end
  end
end

