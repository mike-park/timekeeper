class Api::BillsController < ApplicationController
  respond_to :json
  inherit_resources

  def new
    render json: new_bill_for(current_user)
  end

  private

  def new_bill_for(user)
    @bill ||= begin
                therapist = user.therapist
                bill = therapist.bills.build(billed_on: Date.current)
                bill.bill_items = therapist.unbilled_items
                bill.number = bill.generate_number
                bill
    end
  end

  def resource_params
    params.require(:bill).permit(:id, :billed_on, :therapist_id, :number,
                                 bill_items_attributes: [:id, :event_id, :_destroy])
  end
end
