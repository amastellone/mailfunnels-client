require 'rails_helper'

RSpec.describe "TemplateHyperlinks", type: :request do
  describe "GET /template_hyperlinks" do
    it "works! (now write some real specs)" do
      get template_hyperlinks_path
      expect(response).to have_http_status(200)
    end
  end
end
