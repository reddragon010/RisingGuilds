require 'spec_helper'

describe AttendancesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/attendances" }.should route_to(:controller => "attendances", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/attendances/new" }.should route_to(:controller => "attendances", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/attendances/1" }.should route_to(:controller => "attendances", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/attendances/1/edit" }.should route_to(:controller => "attendances", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/attendances" }.should route_to(:controller => "attendances", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/attendances/1" }.should route_to(:controller => "attendances", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/attendances/1" }.should route_to(:controller => "attendances", :action => "destroy", :id => "1") 
    end
  end
end
