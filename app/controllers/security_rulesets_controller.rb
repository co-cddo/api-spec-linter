# frozen_string_literal: true

class SecurityRulesetsController < ApplicationController

  def show
    @breadcrumbs = { Home: root_path, Uploads: new_upload_path, Rulesets: rulesets_path, Report:"#"}
    upload = Upload.find(session[:upload_id])
    return redirect_to root_path, alert: "Please re upload your file" if upload.nil?

    crunch_hash = JSON.parse(crunch42_data(upload))
    @score = crunch_hash["score"]
    @openapi = crunch_hash["openapiState"]
    @counter = crunch_hash["issueCounter"]
    @criticality = crunch_hash["criticality"]
    @issues =
      crunch_hash["data"]["issues"].map do |_key, issue|
        lines = issue["issues"].pluck("pointer").sort
        [issue["criticality"].to_i, issue["description"], lines]
      end
      @issues = @issues.sort_by{|s| -s[0]}
  end

  private

  def crunch42_data(upload)
    return File.read("fakecrunchresults.json") if ENV["BYPASS_API"] == "true"

    Tempfile.open(upload.oas_file.key) do |oas_file|
      content = upload.oas_file.download.encode('utf-8', 'binary', invalid: :replace, undef: :replace)
      oas_file.write content
      oas_file.rewind
      Linters::CrunchApi::Fetch.new(file: oas_file).lint_to_json
    end
  end

  def ruleset_params
    params.permit(:oas_file)
  end
end
