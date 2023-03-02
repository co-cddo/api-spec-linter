# frozen_string_literal: true
class Upload
  include ActiveModel::Validations
  # Sets the maximum file size allowed as a constant
  # If no value is specified in the environment variables we
  # fall back to 100mb as a hard-coded safety limit
  # Note: The web server configuration may enforce a lower limit
  MAX_FILE_SIZE = Integer(ENV["MAX_FILE_SIZE"] || 100_000)

  attr_accessor :file

  validates :file,
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

  def initialize(file:)
    @file = file
  end
end
