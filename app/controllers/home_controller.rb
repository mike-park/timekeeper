class HomeController < ApplicationController
  def index
    @activities = recent_activities
  end

  private

  def recent_activities
    PublicActivity::Activity.where(owner_type: current_user.class, owner_id: current_user.id).order('created_at desc').limit(100)
  end
end
