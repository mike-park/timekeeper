class BillItemsController < InheritedResources::Base
  respond_to :js, :html

  def create
    create!(notice: 'Event added') { return_url }
  end

  def destroy
    destroy!(notice: 'Event removed') { return_url }
  end

  private

  def return_url
    edit_therapist_bill_path(therapist, bill)
  end

  def therapist
    bill.therapist
  end

  def bill
    @bill_item.bill
  end

  def resource_params
    params.require(:bill_item).permit(:bill_id, :event_id)
  end
end
