require 'spec_helper'

describe 'Events', js: true do
  let(:models) { basic_models }
  let(:user) { models[:user] }
  let(:therapy) { models[:therapies][0] }
  let(:client) { models[:clients][0] }
  let(:therapy1) { models[:therapies][1] }
  let(:client1) { models[:clients][1] }

  before do
    login_user(user)
  end

  def select_therapy(name)
    find('.category', text: name).click
  end

  def cal_week_click(offset, name)
    find(".fc-day#{offset}").click
    find_cal_entry(name)
  end

  def find_cal_entry(name)
    find('.fc-event-title', text: name)
  end

  def find_no_cal_entry(name)
    page.should_not have_css('.fc-event-title', text: name)
  end

  def goto_edit_events
    click_on('Events')
    click_on('Add & Edit')
  end

  def goto_show_events
    click_on('Events')
    click_on('Review')
  end

  def select_client_and_therapy(client_name, therapy_name)
    select_client(client_name)
    select_therapy(therapy_name)
  end

  def add_event(client, therapy)
    goto_edit_events
    select_client_and_therapy(client.full_name, therapy.title)
    cal_week_click(0, client.full_name)

    event = Event.order('id desc').first
    expect(event.client_id).to eq(client.id)
    expect(event.occurred_on).to eq(Date.current.at_beginning_of_week)
    expect(event.event_category_id).to eq(therapy.id)
    expect(event.therapist_id).to eq(user.therapist_id)
  end

  def find_popover_title(title)
    find('.popover-title', text: title)
  end

  def find_popover_content
    find('.popover-content')
  end

  def find_popover_remove_event
    find('#popover-remove-event')
  end

  def add_two_events
    add_event(client, therapy)
    add_event(client1, therapy1)
  end

  def popup_remove_event(name)
    find_cal_entry(name).click
    find_popover_remove_event.click
    find_no_cal_entry(name)
  end

  it "should add an event" do
    render_on_error do
      expect(Event.count).to eq(0)
      add_event(client, therapy)
      expect(Event.count).to eq(1)
    end
  end

  it "should add two events" do
    render_on_error do
      add_two_events
      expect(Event.count).to eq(2)
    end
  end

  it "should show both events" do
    render_on_error do
      add_two_events

      goto_show_events
      find_cal_entry(client.full_name)
      find_cal_entry(client1.full_name)
    end
  end

  it "should have popovers" do
    render_on_error do
      add_two_events
      expect(Event.count).to eq(2)

      goto_show_events
      find_cal_entry(client.full_name).click
      find_popover_title(client.full_name)
      find_popover_content.should have_content(user.therapist.full_name)
      find_cal_entry(client1.full_name).click
      find_popover_title(client1.full_name)
    end
  end

  it "should remove events" do
    render_on_error do
      add_two_events
      expect(Event.count).to eq(2)

      goto_show_events
      popup_remove_event(client.full_name)
      expect(Event.count).to eq(1)
      popup_remove_event(client1.full_name)
      expect(Event.count).to eq(0)
    end
  end
end