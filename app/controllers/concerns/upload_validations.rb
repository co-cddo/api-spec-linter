# frozen_string_literal: true
module UploadValidations
  extend ActiveSupport::Concern

  private

  # Sets the maximum file size allowed as a constant
  # If no value is specified in the environment variables we
  # fall back to 100mb as a hard-coded safety limit
  # Note: The web server configuration may enforce a lower limit
  MAX_FILE_SIZE = Integer(ENV["MAX_FILE_SIZE"] || 100_000)

  def validate_file_upload!
    # The upload button was clicked without choosing a file to upload
    if params[:oas_file].nil?
      flash[:error] = "No file was selected"
      return render :index
    end

    # The file size exceeded the maximum allowed size
    # If no value is specified in the environment variables we
    # fall back to 100mb as a hard-coded safety limit
    # Note: The web server configuration may enforce a lower limit
    if params[:oas_file].size > MAX_FILE_SIZE.kilobytes
      # We log this attempt so that we can see if lots of people are hitting the limit
      logger = Rails.logger
      logger.info "A user tried to upload a file of #{params[:oas_file].size.kilobytes} kilobytes"
      flash[:error] = "Your file exceeds the maximum size of #{MAX_FILE_SIZE} kilobytes"
      render :index
    end

    # If the content-type is not JSON then we also reject the upload
    if params[:oas_file].content_type != "application/json"
      flash[:error] = "This is not a valid JSON file"
      render :index
    end
  end
end
