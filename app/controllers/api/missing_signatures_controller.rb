class Api::MissingSignaturesController < ApplicationController
  respond_to :json

  def index
    render json: collection, each_serializer: MissingSignatureSerializer
  end

  private

  def collection
    therapist = current_user.therapist
    last_bill = Bill.last_bill_by(therapist)
    Event.includes(:client).
        unbilled(last_bill.billed_on).
        of_therapist(therapist).
        order('clients.fingerprint asc, events.occurred_on') if last_bill
  end
end
