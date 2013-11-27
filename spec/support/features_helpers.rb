module Features
  module Helpers
    def render_page(name)
      page.driver.render(name, full: true)
    end

    def render_on_error(&block)
      start = Time.now
      begin
        yield
      rescue Capybara::ElementNotFound => e
        duration = Time.now - start
        render_page('last_page.png')
        raise Capybara::ElementNotFound.new(e.message + " (#{duration})")
      end
    end
  end
end
