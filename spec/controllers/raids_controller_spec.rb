require 'spec_helper'

describe RaidsController do

  def mock_raid(stubs={})
    @mock_raid ||= mock_model(Raid, stubs)
  end

  describe "GET index" do
    it "assigns all raids as @raids" do
      Raid.stub(:find).with(:all).and_return([mock_raid])
      get :index
      assigns[:raids].should == [mock_raid]
    end
  end

  describe "GET show" do
    it "assigns the requested raid as @raid" do
      Raid.stub(:find).with("37").and_return(mock_raid)
      get :show, :id => "37"
      assigns[:raid].should equal(mock_raid)
    end
  end

  describe "GET new" do
    it "assigns a new raid as @raid" do
      Raid.stub(:new).and_return(mock_raid)
      get :new
      assigns[:raid].should equal(mock_raid)
    end
  end

  describe "GET edit" do
    it "assigns the requested raid as @raid" do
      Raid.stub(:find).with("37").and_return(mock_raid)
      get :edit, :id => "37"
      assigns[:raid].should equal(mock_raid)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created raid as @raid" do
        Raid.stub(:new).with({'these' => 'params'}).and_return(mock_raid(:save => true))
        post :create, :raid => {:these => 'params'}
        assigns[:raid].should equal(mock_raid)
      end

      it "redirects to the created raid" do
        Raid.stub(:new).and_return(mock_raid(:save => true))
        post :create, :raid => {}
        response.should redirect_to(raid_url(mock_raid))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved raid as @raid" do
        Raid.stub(:new).with({'these' => 'params'}).and_return(mock_raid(:save => false))
        post :create, :raid => {:these => 'params'}
        assigns[:raid].should equal(mock_raid)
      end

      it "re-renders the 'new' template" do
        Raid.stub(:new).and_return(mock_raid(:save => false))
        post :create, :raid => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested raid" do
        Raid.should_receive(:find).with("37").and_return(mock_raid)
        mock_raid.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :raid => {:these => 'params'}
      end

      it "assigns the requested raid as @raid" do
        Raid.stub(:find).and_return(mock_raid(:update_attributes => true))
        put :update, :id => "1"
        assigns[:raid].should equal(mock_raid)
      end

      it "redirects to the raid" do
        Raid.stub(:find).and_return(mock_raid(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(raid_url(mock_raid))
      end
    end

    describe "with invalid params" do
      it "updates the requested raid" do
        Raid.should_receive(:find).with("37").and_return(mock_raid)
        mock_raid.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :raid => {:these => 'params'}
      end

      it "assigns the raid as @raid" do
        Raid.stub(:find).and_return(mock_raid(:update_attributes => false))
        put :update, :id => "1"
        assigns[:raid].should equal(mock_raid)
      end

      it "re-renders the 'edit' template" do
        Raid.stub(:find).and_return(mock_raid(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested raid" do
      Raid.should_receive(:find).with("37").and_return(mock_raid)
      mock_raid.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the raids list" do
      Raid.stub(:find).and_return(mock_raid(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(raids_url)
    end
  end

end
