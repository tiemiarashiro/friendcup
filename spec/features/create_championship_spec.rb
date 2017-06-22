require 'rails_helper'

describe 'Create Championship', type: :feature do
  include Warden::Test::Helpers
  before(:each) do
    user = FactoryGirl.create(:user)
    login_as (user)
    
  end

  it 'should be in create championship page' do
    visit new_championship_path
    expect(page).to have_content("Detalhes do campeonato")
  end
  
  it 'should create a championship' do 
      visit new_championship_path
      within "#new_championship" do
        fill_in "championship_name", with: 'Teste'
        fill_in "championship_game", with: 'Teste'
        select "4", :from => "championship_starts_at_3i"
        select "Maio", :from => "championship_starts_at_2i"
        select "2015", :from => "championship_starts_at_1i"
        select "7", :from => "championship_ends_at_3i"
        select "Junho", :from => "championship_ends_at_2i"
        select "2015", :from => "championship_ends_at_1i"
        #isso não está funcionando
        meudeus = page.find('#championship_championship_type_id option', text: "Todos contra todos") 
        select meudeus, :from => "championship_championship_type_id"
        #option = find('.control-label select required', text: '4').click
        #select "Todos contra todos", from: "championship_championship_type_id"
        select user.name, :from => "championship_user_ids"
        
      end
  end
end

