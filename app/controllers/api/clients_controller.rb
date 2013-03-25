class Api::ClientsController < ApplicationController
  respond_to :json
  inherit_resources

  def index
    scope = Client
    unless params[:all] == 'true'
      scope = scope.active
    end
    if params[:therapist_id]
      therapist = Therapist.find(params[:therapist_id])
      scope = scope.of_therapist(therapist)
    end
    @clients = scope.all
    render json: @clients, each_serializer: ClientIndexSerializer
  end

  def show
    render json: resource, serializer: ClientShowSerializer, root: false
  end
end
