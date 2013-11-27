module Features
  module Helpers
    def login_user(user = nil)
      user ||= FactoryGirl.create(:user_with_therapist)
      render_on_error do
        visit root_path
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button 'sign_in'
        page.should have_text("IFF Timekeeper #{user.name}")
      end
      user
    end

    def render_page(name = 'last_page.png')
      page.driver.render(name, full: true)
    end

    def render_on_error(&block)
      start = Time.now
      begin
        yield
      rescue Capybara::ElementNotFound => e
        duration = Time.now - start
        render_page
        raise Capybara::ElementNotFound.new(e.message + " (#{duration})")
      end
    end
  end
end
