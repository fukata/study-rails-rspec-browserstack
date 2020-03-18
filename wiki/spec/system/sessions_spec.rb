require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  describe 'Login' do
    before(:each) do
      visit login_path
    end

    it 'Have Login Section' do
      within('h1') do
        expect(page).to have_text 'Login'
      end
    end

    it 'Display error messages' do
      fill_in 'user_name', with: 'test'
      fill_in 'user_password', with: 'test'
      click_button 'commit'

      expect(page).to have_selector('#error_explanation')
    end
  end
end
