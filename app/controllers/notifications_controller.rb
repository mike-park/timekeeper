class NotificationsController < InheritedResources::Base

  private

  def collection
    @notifications ||= PublicActivity::Activity.order('created_at desc').limit(100)
  end
end
