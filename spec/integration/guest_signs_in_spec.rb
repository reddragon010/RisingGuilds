require 'spec_helper'

describe 'as a guest on the sign in page' do

  #Make sure your factory generates a valid user for your authentication system
  let(:user) { Factory(:User) }

  #Browse to the homepage and click the Sign In link
  before do
    visit root_path
    click 'Login / SignUp'
  end

  context 'with valid credentials' do

    #Fill in the form with the user’s credentials and submit it.
    before do
      fill_in 'Login', :with => user.login
      fill_in 'Password', :with => 'password'
      click 'Login'
    end

    it 'has a sign out link' do
      page.should have_xpath('//a', :text => 'Logout')
    end

    it 'knows who I am' do
      page.should have_content("You are logged in as #{user.login.capitalize}")
    end

  end

  context 'with invalid credentials' do

    #No form entry should produce an error
    before do
      click 'Login'
    end

    it 'has errors' do
      page.should have_css(".error")
    end

  end

end