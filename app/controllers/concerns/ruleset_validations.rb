module RulesetValidations
  extend ActiveSupport::Concern

  private

  def validate_file_upload!
    if params[:oas_file].nil?
      flash[:error] = "Please upload a file"
      return render 'new'
    end

    if params[:oas_file].content_type != "application/json"
      flash[:error] = "This is not a valid JSON file"
      render 'new'
    end
  end

  def validate_ruleset_name!
    redirect_to root_path if @ruleset_name.nil?
  end
end
