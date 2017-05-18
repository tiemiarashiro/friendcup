require 'rails_helper'

describe 'Sign Up', type: :feature do
  before(:each) do
    visit new_user_registration_path  
  end
  
  it 'should be the sign up page' do
    expect(page).to have_content(:password_confirmation)
  end
  
  it 'should sign up' do
    name = 'Jackson'
    email = 'five@gmail.com'
    password = '123456'
    
    within "#new_user" do
      fill_in "user_email", with: email
      fill_in "user_name", with: name
      fill_in "user_password", with: password
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password
    end
    
    first('input[type="submit"]').click
    
    expect(page).to have_content("Welcome!")
  end
  
  it 'should not sign up: password too short' do
    name = 'Jackson'
    email = 'five@gmail.com'
    password = '123'
    
    within "#new_user" do
      fill_in "user_email", with: email
      fill_in "user_name", with: name
      fill_in "user_password", with: password
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password
    end
    
    first('input[type="submit"]').click
    
    expect(page).to have_content("Password must have at least")
  end
  
  
  
end