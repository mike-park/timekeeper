class Api::NotificationsController < ApplicationController
  respond_to :json
  inherit_resources

  def index
    render json: collection, each_serializer: NotificationSerializer
  end

  private

  def collection
    @notifications ||= PublicActivity::Activity.order('created_at desc').where('created_at > ?', DateTime.now - 1.month)
  end
end
