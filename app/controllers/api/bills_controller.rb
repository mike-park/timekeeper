class Api::BillsController < ApplicationController
  respond_to :json
  inherit_resources

  def new
    render json: new_resource
  end

  def edit
    render json: resource
  end

  private

  def new_resource
    bill = Bill.new
    bill.therapist ||= therapist
    bill.billed_on ||= Date.current
    bill.number ||= bill.generate_number
    bill
  end

  def therapist
    current_user.therapist
  end

  def resource_params
    params.require(:bill).permit(:id, :billed_on, :therapist_id, :number,
                                 bill_items_attributes: [:id, :event_id, :_destroy])
  end
end
