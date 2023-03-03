# frozen_string_literal: true

class UploadsController < ApplicationController
  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(
      oas_file: file_params[:oas_file]
    )

    # Save this to the database once we find out if we can use the database
    # For now we can store the info in the session
    if @upload.save
      session[:upload_id] = @upload.id
      redirect_to :rulesets
    else
      render "new"
    end
  end

  private

  def file_params
    params.permit(:oas_file)
  end
end
