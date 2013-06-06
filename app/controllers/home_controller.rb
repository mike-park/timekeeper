class HomeController < ApplicationController
  def index
    @activities = recent_activities
  end

  private

  def recent_activities
    scope = PublicActivity::Activity.includes(:owner).order('created_at desc')
    if therapist = current_user.therapist
      scope = scope.where(recipient_type: therapist.class, recipient_id: therapist.id)
    end
    scope.limit(100)
  end
end
