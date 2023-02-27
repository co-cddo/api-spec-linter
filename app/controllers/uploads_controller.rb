# frozen_string_literal: true

class UploadsController < ApplicationController
  include UploadValidations
  before_action :validate_file_upload!, only: [:create]
  before_action :set_file, only: %i[create]
  before_action :clear_errors

  def index
  end

  def create
    redirect_to :rulesets
  end

  def set_file
    session[:oas_file_name] = file_params[:oas_file].original_filename
    session[:oas_file_body] = file_params[:oas_file].read
  end

  def file_params
    params.permit(:oas_file)
  end

  def clear_errors
    flash[:error] = nil
  end

end
