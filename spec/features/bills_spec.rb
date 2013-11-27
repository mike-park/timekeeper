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

  def find_client_event(client, event)
    find("#client-#{client.id}").find('.bill-item', text: event_title(event))
  end

  def match_event_included(client, event, result)
    node = find_client_event(client, event)
    included = node['class'].include?('event-included')
    expect([event, included]).to eq([event, result])
  end

  def match_events_in_bill(bill, events)
    expect(bill.bill_items.map(&:event_id)).to eq(events.map(&:id))
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
          add_event(client: client, event_category: therapy, occurred_on: Date.current - 1.month),
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
        events.each do |event|
          find_client_event(client, event)
        end
      end
    end

    context "included events" do
      it "should have 1 event included & the other not included" do
        render_on_error do
          goto_new_bill
          match_event_included(client, events[0], false)
          match_event_included(client, events[1], true)
        end
      end

      it "should have all included events" do
        render_on_error do
          goto_new_bill
          click_on('Include All Activities')
          events.each do |event|
            match_event_included(client, event, true)
          end
        end
      end

      it "should have no included events" do
        render_on_error do
          goto_new_bill
          click_on('Exclude All Activities')
          events.each do |event|
            match_event_included(client, event, false)
          end
        end
      end

      it "should toggle included events" do
        render_on_error do
          goto_new_bill
          find_client_event(client, events[0]).click
          find_client_event(client, events[1]).click
          match_event_included(client, events[0], true)
          match_event_included(client, events[1], false)
        end
      end
    end

    context "save bill" do
      it "should save with defaults" do
        render_on_error do
          goto_new_bill
          click_on('Save Bill')
          page.should have_link('Print Bill')
          expect(Bill.count).to eq(1)
          bill = Bill.first
          match_events_in_bill(bill, [events[1]])
        end
      end

      it "should save with changes" do
        render_on_error do
          goto_new_bill
          # angular popup doesn't like capybara fill_in
          #fill_in(:billedOn, with: '01.12.2013')
          fill_in(:number, with: 'ABC123')
          find_client_event(client, events[0]).click
          click_on('Save Bill')
          page.should have_link('Print Bill')

          expect(Bill.count).to eq(1)
          bill = Bill.first
          match_events_in_bill(bill, events)
        end
      end
    end
  end
end
