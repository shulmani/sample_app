require 'spec_helper'

describe "LayoutLinks" do
  it "should have a title at /" do
     get '/'
     response.should have_selector("title",:content=>"Home")
  end

  it "should have a title at /about" do
     get '/about'
     response.should have_selector("title",:content=>"About")
  end

  it "should have a title at /contact" do
       get '/contact'
       response.should have_selector("title",:content=>"Contact")
  end

  it "should have a title at /help" do
       get '/help'
       response.should have_selector("title",:content=>"Help")
  end

  it "should have a title at /signup" do
       get '/signup'
       response.should have_selector("title",:content=>"Sign up")
  end

  it "should visit the proper links" do
    visit root_path

    click_link "Sign up now!"
    response.should have_selector("title",:content=>"Sign up")

    click_link "About"
    response.should have_selector("title", :content=>"About")

    click_link "Help"
    response.should have_selector("title",:content=>"Help")

    click_link "Contact"
    response.should have_selector("title",:content=>"Contact")


  end
end

