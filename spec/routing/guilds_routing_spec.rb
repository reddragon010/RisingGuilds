require 'spec_helper'

describe GuildsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/guilds" }.should route_to(:controller => "guilds", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/guilds/new" }.should route_to(:controller => "guilds", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/guilds/1" }.should route_to(:controller => "guilds", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/guilds/1/edit" }.should route_to(:controller => "guilds", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/guilds" }.should route_to(:controller => "guilds", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/guilds/1" }.should route_to(:controller => "guilds", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/guilds/1" }.should route_to(:controller => "guilds", :action => "destroy", :id => "1") 
    end
  end
end
