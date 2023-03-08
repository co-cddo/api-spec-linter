RSpec.describe "rulesets/index.html.erb", type: :view do

  before do
    render
  end

  it "displays the page title" do
    expect(rendered).to have_selector("h1.govuk-heading-xl", text: "GOV.UK OpenAPI Linting Service")
  end

  it "displays the ruleset options" do
    assert_select("input[type=radio][name=ruleset_name][value=ruleset_low]")
    assert_select("input[type=radio][name=ruleset_name][value=ruleset_medium][checked]")
    assert_select("input[type=radio][name=ruleset_name][value=ruleset_high]")
    assert_select("input[type=submit][value=Continue]")
  end
end
