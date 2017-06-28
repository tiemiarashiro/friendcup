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
  
  it "Change password successfully" do
    
    fill_in "user_current_password", with: "123456"
    fill_in "user_password", with: "teste1"
    fill_in "user_password_confirmation", with: "teste1"
        
    first('input[type="submit"]').click
        
    expect(page).to have_content("A sua conta foi atualizada com sucesso")
        
  end
  
  it "Change password error - new password too short" do
     
    fill_in "user_current_password", with: "123456"
    fill_in "user_password", with: "12"
    fill_in "user_password_confirmation", with: "12"
        
    first('input[type="submit"]').click
        
    expect(page).to have_content("deve conter ao menos")
      
  end
  
  it "Change password error - current password invalid" do
    
    fill_in "user_current_password", with: "12"
    fill_in "user_password", with: "teste1"
    fill_in "user_password_confirmation", with: "teste1"
        
    first('input[type="submit"]').click
        
    expect(page).to have_content("Senha atual incorreta")
     
  end
  
  it "Change password error - Different passwords" do
  
    fill_in "user_current_password", with: "123456"
    fill_in "user_password", with: "teste1"
    fill_in "user_password_confirmation", with: "teste2"
        
    first('input[type="submit"]').click
        
    expect(page).to have_content("As senhas informadas não conferem")
  
  end
  
end