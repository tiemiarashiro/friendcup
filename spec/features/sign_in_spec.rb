require 'rails_helper'

describe 'Sign In', type: :feature do
  before(:each) do
    visit user_session_path  
  end
  
  it 'should be the sign in page' do
    expect(page).to have_content(:sign_in)
  end
  
  it 'should sign in and sign out' do
    user = User.create!(email: "five@gmail.com", password: "123456", name: "Jackson")
    email = user.email
    password = user.password
    
    within "#new_user" do
      fill_in "user_email", with: email
      fill_in "user_password", with: password
    end
    
    first('input[type="submit"]').click
    
    expect(page).to have_content("Signed in successfully.")
    
    click_link("Sair")
    
    expect(page).to have_content("Signed out successfully")
    
  end

  it 'should not sign in: password incorrect' do
    email = 'five@gmail.com'
    password = '123'
    
    within "#new_user" do
      fill_in "user_email", with: email
      fill_in "user_password", with: password
    end
    
    first('input[type="submit"]').click
    
    expect(page).to have_content("Invalid Email or password")
  end
  
  
  
end