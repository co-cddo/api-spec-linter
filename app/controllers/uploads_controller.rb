# frozen_string_literal: true

class UploadsController < ApplicationController
  include UploadValidations
  before_action :clear_errors

  def index
  end

  def create
    upload = Upload.new(file: file_params[:oas_file])

    # Save this to the database once we find out if we can use the database
    # For now we can store the info in the session
    if upload.validate
      session[:oas_file_name] = file_params[:oas_file].original_filename
      session[:oas_file_body] = file_params[:oas_file].read
      redirect_to :rulesets
    else
      render "index"
    end
  end

  private

  def file_params
    params.permit(:oas_file)
  end

  def clear_errors
    flash[:error] = nil
  end
end
