require 'rails_helper'

describe 'Home', type: :request do
  before(:each) do
    visit root_path
  end

  context 'when the user is logged' do
    before do
      user = FactoryGirl.create(:user)

      visit new_user_session_path
      within "#new_user" do
        fill_in "user_email", with: user.email
        fill_in "user_password", with: '123456'
      end
      # click_button('Login')
      first('input[type="submit"]').click
    end

    specify 'i can access my home page' do
      expect(current_path).to eq root_path
    end

    specify 'the menu is visible' do
      expect(page).to have_selector('#menu-navbar')
    end
  end

  context 'when the user is not logged' do
    specify 'the menu is invisible' do
      expect(page).not_to have_selector('#menu-navbar')
    end
  end

end
