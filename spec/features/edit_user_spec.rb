require 'rails_helper'
require 'spec_helper'

describe 'Edit User', type: :feature do
  before(:each) do
      
    #Criar um usuario e fazer login
    user = User.create!(email: "five@gmail.com", password: "123456", name: "Jackson")
    
    visit user_session_path  
    
    email = user.email
    password = user.password
    
    within "#new_user" do
      fill_in "user_email", with: email
      fill_in "user_password", with: password
    end
    
    first('input[type="submit"]').click
    
    #Visitar a página de edição
    visit edit_user_registration_path
    
  end
  
  it 'Visit edit page' do
    
    expect(page).to have_content("Edit")
    
  end
  
  it 'Edit name successfully' do
    
    fill_in "user_name", with: "Jordan"
    fill_in "user_current_password", with: "123456"
    
    first('input[type="submit"]').click
    
    expect(page).to have_content("A sua conta foi atualizada com sucesso")
    
  end
  
end