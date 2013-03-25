require "spec_helper"

describe EventCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/event_categories").should route_to("event_categories#index")
    end

    it "routes to #new" do
      get("/event_categories/new").should route_to("event_categories#new")
    end

    it "routes to #show" do
      get("/event_categories/1").should route_to("event_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/event_categories/1/edit").should route_to("event_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/event_categories").should route_to("event_categories#create")
    end

    it "routes to #update" do
      put("/event_categories/1").should route_to("event_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/event_categories/1").should route_to("event_categories#destroy", :id => "1")
    end

  end
end
