require 'spec_helper'

describe 'Bills', js: true do
  let(:models) { basic_models }
  let(:user) { models[:user] }
  let(:therapist) { user.therapist }
  let(:therapy) { models[:therapies][0] }
  let(:client) { models[:clients][0] }
  let(:therapy1) { models[:therapies][1] }
  let(:client1) { models[:clients][1] }

  before do
    login_user(user)
  end

  def goto_new_bill
    click_on('Bills')
    click_on('Add Bill')
  end

  def add_event(options = {})
    options = {
        client: client,
        therapist: therapist,
        event_category: therapy,
        occurred_on: Date.current
    }.merge(options)
    FactoryGirl.create(:event, options)
  end

  def find_client_heading(client)
    page.should have_css(".panel-heading", text: client.full_name)
  end

  def find_client_events(client, count)
    panel = find("#client-#{client.id}")
    panel.should have_css('.bill-item', count: count)
    panel.all('.bill-item')
  end

  def event_title(event)
    date = event.occurred_on.strftime('%d.%m')
    "#{date} #{event.event_category_title}"
  end

  it 'should show a new bill' do
    render_on_error do
      goto_new_bill
      page.should have_content('Step 2')
    end
  end

  it "should have clients" do
    render_on_error do
      models[:clients].each { |client| add_event(client: client) }

      goto_new_bill
      models[:clients].each { |client| find_client_heading(client) }
    end
  end

  context "client with 2 events" do
    let(:events) {
      [
          add_event(client: client, event_category: therapy, occurred_on: Date.yesterday),
          add_event(client: client, event_category: therapy1),
      ]
    }
    before do
      events
    end

    it "should have 2 events" do
      render_on_error do
        goto_new_bill
        find_client_events(client, 2)
      end
    end

    it "should have event names" do
      render_on_error do
        goto_new_bill
        items = find_client_events(client, 2)
        (0..1).each do |n|
          items[n].should have_content(event_title(events[n]))
        end
      end
    end
  end
end