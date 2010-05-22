require 'spec_helper'

describe AttendancesController do

  def mock_attendance(stubs={})
    @mock_attendance ||= mock_model(Attendance, stubs)
  end

  describe "GET index" do
    it "assigns all attendances as @attendances" do
      Attendance.stub(:find).with(:all).and_return([mock_attendance])
      get :index
      assigns[:attendances].should == [mock_attendance]
    end
  end

  describe "GET show" do
    it "assigns the requested attendance as @attendance" do
      Attendance.stub(:find).with("37").and_return(mock_attendance)
      get :show, :id => "37"
      assigns[:attendance].should equal(mock_attendance)
    end
  end

  describe "GET new" do
    it "assigns a new attendance as @attendance" do
      Attendance.stub(:new).and_return(mock_attendance)
      get :new
      assigns[:attendance].should equal(mock_attendance)
    end
  end

  describe "GET edit" do
    it "assigns the requested attendance as @attendance" do
      Attendance.stub(:find).with("37").and_return(mock_attendance)
      get :edit, :id => "37"
      assigns[:attendance].should equal(mock_attendance)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created attendance as @attendance" do
        Attendance.stub(:new).with({'these' => 'params'}).and_return(mock_attendance(:save => true))
        post :create, :attendance => {:these => 'params'}
        assigns[:attendance].should equal(mock_attendance)
      end

      it "redirects to the created attendance" do
        Attendance.stub(:new).and_return(mock_attendance(:save => true))
        post :create, :attendance => {}
        response.should redirect_to(attendance_url(mock_attendance))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved attendance as @attendance" do
        Attendance.stub(:new).with({'these' => 'params'}).and_return(mock_attendance(:save => false))
        post :create, :attendance => {:these => 'params'}
        assigns[:attendance].should equal(mock_attendance)
      end

      it "re-renders the 'new' template" do
        Attendance.stub(:new).and_return(mock_attendance(:save => false))
        post :create, :attendance => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested attendance" do
        Attendance.should_receive(:find).with("37").and_return(mock_attendance)
        mock_attendance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :attendance => {:these => 'params'}
      end

      it "assigns the requested attendance as @attendance" do
        Attendance.stub(:find).and_return(mock_attendance(:update_attributes => true))
        put :update, :id => "1"
        assigns[:attendance].should equal(mock_attendance)
      end

      it "redirects to the attendance" do
        Attendance.stub(:find).and_return(mock_attendance(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(attendance_url(mock_attendance))
      end
    end

    describe "with invalid params" do
      it "updates the requested attendance" do
        Attendance.should_receive(:find).with("37").and_return(mock_attendance)
        mock_attendance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :attendance => {:these => 'params'}
      end

      it "assigns the attendance as @attendance" do
        Attendance.stub(:find).and_return(mock_attendance(:update_attributes => false))
        put :update, :id => "1"
        assigns[:attendance].should equal(mock_attendance)
      end

      it "re-renders the 'edit' template" do
        Attendance.stub(:find).and_return(mock_attendance(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested attendance" do
      Attendance.should_receive(:find).with("37").and_return(mock_attendance)
      mock_attendance.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the attendances list" do
      Attendance.stub(:find).and_return(mock_attendance(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(attendances_url)
    end
  end

end
