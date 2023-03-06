# frozen_string_literal: true

# == Schema Information
#
# Table name: uploads
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Upload < ApplicationRecord
  include ActiveModel::Validations
  # Sets the maximum file size allowed as a constant
  # If no value is specified in the environment variables we
  # fall back to 100mb as a hard-coded safety limit
  # Note: The web server configuration may enforce a lower limit
  MAX_FILE_SIZE = Integer(ENV["MAX_FILE_SIZE"] || 100_000)

  has_one_attached :oas_file

  validates :oas_file,
            presence: {
              message: "No file was selected"
            },
            file_size: {
              less_than_or_equal_to: MAX_FILE_SIZE.kilobytes,
              message: "Your file exceeds the maximum size of #{MAX_FILE_SIZE} kilobytes"
            },
            file_content_type: {
              allow: ["application/json"],
              message: "This is not a valid JSON file"
            }
end
