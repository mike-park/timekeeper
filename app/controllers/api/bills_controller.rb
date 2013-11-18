class Api::BillsController < ApplicationController
  respond_to :json
  inherit_resources

  def show
    render json: resource, serializer: BillshowSerializer, root: false
  end

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
end
