require "rails_helper"

RSpec.describe TemplateHyperlinksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/template_hyperlinks").to route_to("template_hyperlinks#index")
    end


    it "routes to #show" do
      expect(:get => "/template_hyperlinks/1").to route_to("template_hyperlinks#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/template_hyperlinks").to route_to("template_hyperlinks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/template_hyperlinks/1").to route_to("template_hyperlinks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/template_hyperlinks/1").to route_to("template_hyperlinks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/template_hyperlinks/1").to route_to("template_hyperlinks#destroy", :id => "1")
    end

  end
end
