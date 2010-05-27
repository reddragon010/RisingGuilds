require 'spec_helper'

describe RaidsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/raids" }.should route_to(:controller => "raids", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/raids/new" }.should route_to(:controller => "raids", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/raids/1" }.should route_to(:controller => "raids", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/raids/1/edit" }.should route_to(:controller => "raids", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/raids" }.should route_to(:controller => "raids", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/raids/1" }.should route_to(:controller => "raids", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/raids/1" }.should route_to(:controller => "raids", :action => "destroy", :id => "1") 
    end
  end
end
