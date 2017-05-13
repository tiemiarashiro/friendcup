require 'rails_helper'

describe 'Home', type: :request do
  before(:each) do
    visit root_path
  end

  specify 'the correct menu item is active' do
    active_item = page.find('.navbar li.active')
    expect(active_item.text).to eq 'Home'
  end

end
