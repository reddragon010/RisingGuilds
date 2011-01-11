require 'spec_helper'

describe CharactersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/characters" }.should route_to(:controller => "characters", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/characters/new" }.should route_to(:controller => "characters", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/characters/1" }.should route_to(:controller => "characters", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/characters/1/edit" }.should route_to(:controller => "characters", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/characters" }.should route_to(:controller => "characters", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/characters/1" }.should route_to(:controller => "characters", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/characters/1" }.should route_to(:controller => "characters", :action => "destroy", :id => "1") 
    end
  end
end
