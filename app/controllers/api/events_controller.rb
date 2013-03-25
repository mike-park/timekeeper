class Api::EventsController < ApplicationController
  respond_to :json
  inherit_resources

  def index
    scope = Event.includes(:event_category, :therapist, :client, :bill)
    if params[:therapist_id]
      therapist = Therapist.find(params[:therapist_id])
      scope = scope.of_therapist(therapist)
    end
    if params[:client_id]
      scope = scope.where(client_id: params[:client_id])
    end
    if params[:event_category_id]
      scope = scope.where(event_category_id: params[:event_category_id])
    end
    if params[:start]
      scope = scope.where('occurred_on >= ?', Date.parse(params[:start]))
    end
    if params[:end]
      scope = scope.where('occurred_on <= ?', Date.parse(params[:end]))
    end
    if params[:unbilled] == 'true'
      scope = scope.where(bill_id: nil)
    end
    @events = scope.all
    index!
  end

  private

  def resource_params
    params.require(:event).permit(:therapist_id, :client_id, :occurred_on, :event_category_id)
  end

end
