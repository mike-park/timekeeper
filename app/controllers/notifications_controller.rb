class NotificationsController < InheritedResources::Base

  private

  def collection
    # loaded via ajax and api
    []
  end
end
