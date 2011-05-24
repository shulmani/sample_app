require 'spec_helper'

describe UsersController do
  render_views

  describe "Get 'show'"do
    before(:each) do
          @user=Factory(:user)
    end

    it "should be successful"do
      get :show , :id =>@user
      response.should be_success
    end

    it "should get the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it  "should have the proper title" do
      get  'new'
      response.should have_selector("title",:content=>"Sign up")
    end
  end

  describe "should show the right page and the page elements"do

    it "should have the right title"do
      get ':show'
      response.should have_selector("title",:content=>@user.name)
    end

    it "should have the right username"do
      get ':show'
      response.should have_selector("<h1>",:content=>@user.name)
    end

    it "should have the right image"do
      get ':show'
      response.should have_selector("h1>img", :class=>"gravatar")
    end
  end

end
