class EventsController < InheritedResources::Base
  def destroy
    destroy! { client_path(@event.client) }
  end
end
