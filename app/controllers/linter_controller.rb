class LinterController < ApplicationController

  def new
    return render 'security_ruleset' if params[:which_ruleset] == 'security_ruleset'

    render 'government_ruleset'
  end
end
