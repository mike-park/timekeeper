class Api::MissingSignaturesController < ApplicationController
  respond_to :json

  def index
    render json: collection, each_serializer: MissingSignatureSerializer
  end

  private

  def collection
    therapist = current_user.therapist
    last_bill = Bill.last_bill_by(therapist)
    MissingSignature.find(therapist, last_bill.billed_on)
  end
end
