# frozen_string_literal: true

class SecurityRulesetsController < ApplicationController

  def show
    upload = Upload.find(session[:upload_id])
    return redirect_to root_path, alert: "Please re upload your file" if upload.nil?

    crunch_hash = JSON.parse(crunch42_data(upload))
    @score = crunch_hash["score"]
    @openapi = crunch_hash["openapiState"]
    @counter = crunch_hash["issueCounter"]
    @criticality = crunch_hash["criticality"]
    @issues =
      crunch_hash["data"]["issues"].map do |_key, issue|
        lines = issue["issues"].pluck("pointer")
        [issue["criticality"], issue["description"], lines]
      end
  end

  private

  def crunch42_data(upload)
    return File.read("fakecrunchresults.json") if ENV["BYPASS_API"] == "true"

    Tempfile.open(upload.oas_file.key) do |oas_file|
      oas_file.write(upload.oas_file.download)
      oas_file.rewind
      Linters::CrunchApi::Fetch.new(file: oas_file).lint_to_json
    end
  end

  def ruleset_params
    params.permit(:oas_file)
  end
end
