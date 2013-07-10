class Api::MissingSignaturesController < ApplicationController
  respond_to :json

  def index
    render json: collection, each_serializer: MissingSignatureSerializer
  end

  private

  def collection
    @missing_signatures ||= MissingSignatureService.new(current_user.therapist).events
  end
end
