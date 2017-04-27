require 'rails_helper'

describe 'Home', type: :request do
  before(:each) do
    visit root_path  
  end
  
  it 'has the logo' do
    expect(page).to have_selector(".logo")
  end
  
end