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

    def debug_page
      page.driver.debug
    end

    def basic_models
      user = FactoryGirl.create(:user_with_therapist)
      therapist_list = user.therapist.abbrv
      {
          user: user,
          therapies: [
              FactoryGirl.create(:event_category, abbrv: 'et', title: 'einzel therapie'),
              FactoryGirl.create(:event_category, abbrv: 'gt', title: 'gruppen therapie')
          ],
          clients: [
              FactoryGirl.create(:client, first_name: 'John', last_name: 'Smith', therapist_list: therapist_list),
              FactoryGirl.create(:client, first_name: 'Sally', last_name: 'Jax', therapist_list: therapist_list)
          ]
      }
    end

    def select_client(name)
      find('#s2id_select-client .select2-chosen').click
      find('.select2-result-label', text: name).click
    end


  end
end
