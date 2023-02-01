class LinterController < ApplicationController
  def new
    if params[:which_ruleset] == "security_ruleset"
      return render "security_ruleset"
    end

    render "government_ruleset"
  end
end
