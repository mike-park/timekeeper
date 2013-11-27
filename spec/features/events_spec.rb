require 'spec_helper'

describe 'Events', js: true do
  let(:therapy1) { FactoryGirl.create(:event_category, title: 'therapy1')}
  let(:client1) { FactoryGirl.create(:client, first_name: 'John', last_name: 'Smith')}
  let(:name) { client1.full_name }

  def setup_models
    therapy1
    client1
  end

  before do
    setup_models
    @user = login_user
  end

  it "should add an event" do
    render_on_error do
      click_on('Events')
      click_on('Add & Edit')
      check('Include all clients')
      click_on('Select Client')
      find('.select2-result-label', text: name).click
      find('.category', text: 'therapy1').click
      find('.fc-day0').click
      find('.fc-event-title', text: name)
      expect(Event.count).to eq(1)
      event = Event.first
      expect(event.client_id).to eq(client1.id)
      expect(event.occurred_on).to eq(Date.current.at_beginning_of_week)
      expect(event.event_category_id).to eq(therapy1.id)
      expect(event.therapist_id).to eq(@user.therapist_id)
    end
  end
end