require 'spec_helper'

describe 'Simple Login', js:true do
  it "should login" do
    user = FactoryGirl.create(:user_with_therapist)
    render_on_error do
      visit root_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'sign_in'
      page.should have_text("IFF Timekeeper #{user.name}")
    end
  end
end