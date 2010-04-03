require 'spec_helper'

describe GuildsController do

  def mock_guild(stubs={})
    @mock_guild ||= mock_model(Guild, stubs)
  end

  describe "GET index" do
    it "assigns all guilds as @guilds" do
      Guild.stub(:find).with(:all).and_return([mock_guild])
      get :index
      assigns[:guilds].should == [mock_guild]
    end
  end

  describe "GET show" do
    it "assigns the requested guild as @guild" do
      Guild.stub(:find).with("37").and_return(mock_guild)
      get :show, :id => "37"
      assigns[:guild].should equal(mock_guild)
    end
  end

  describe "GET new" do
    it "assigns a new guild as @guild" do
      Guild.stub(:new).and_return(mock_guild)
      get :new
      assigns[:guild].should equal(mock_guild)
    end
  end

  describe "GET edit" do
    it "assigns the requested guild as @guild" do
      Guild.stub(:find).with("37").and_return(mock_guild)
      get :edit, :id => "37"
      assigns[:guild].should equal(mock_guild)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created guild as @guild" do
        Guild.stub(:new).with({'these' => 'params'}).and_return(mock_guild(:save => true))
        post :create, :guild => {:these => 'params'}
        assigns[:guild].should equal(mock_guild)
      end

      it "redirects to the created guild" do
        Guild.stub(:new).and_return(mock_guild(:save => true))
        post :create, :guild => {}
        response.should redirect_to(guild_url(mock_guild))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved guild as @guild" do
        Guild.stub(:new).with({'these' => 'params'}).and_return(mock_guild(:save => false))
        post :create, :guild => {:these => 'params'}
        assigns[:guild].should equal(mock_guild)
      end

      it "re-renders the 'new' template" do
        Guild.stub(:new).and_return(mock_guild(:save => false))
        post :create, :guild => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested guild" do
        Guild.should_receive(:find).with("37").and_return(mock_guild)
        mock_guild.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :guild => {:these => 'params'}
      end

      it "assigns the requested guild as @guild" do
        Guild.stub(:find).and_return(mock_guild(:update_attributes => true))
        put :update, :id => "1"
        assigns[:guild].should equal(mock_guild)
      end

      it "redirects to the guild" do
        Guild.stub(:find).and_return(mock_guild(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(guild_url(mock_guild))
      end
    end

    describe "with invalid params" do
      it "updates the requested guild" do
        Guild.should_receive(:find).with("37").and_return(mock_guild)
        mock_guild.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :guild => {:these => 'params'}
      end

      it "assigns the guild as @guild" do
        Guild.stub(:find).and_return(mock_guild(:update_attributes => false))
        put :update, :id => "1"
        assigns[:guild].should equal(mock_guild)
      end

      it "re-renders the 'edit' template" do
        Guild.stub(:find).and_return(mock_guild(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested guild" do
      Guild.should_receive(:find).with("37").and_return(mock_guild)
      mock_guild.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the guilds list" do
      Guild.stub(:find).and_return(mock_guild(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(guilds_url)
    end
  end

end
