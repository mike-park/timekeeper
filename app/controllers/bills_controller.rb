class BillsController < InheritedResources::Base
  belongs_to :therapist, optional: true
  respond_to :pdf, :html

  def create
    @bill = parent.bills.build(resource_params)
    if @bill.bill_items.size == 0
      redirect_to therapist_bills_path(parent), alert: t('bills.no_events_selected',
                                                         default: 'Bill was not created. No events were selected.')
      return
    end
    create!
  end

  def show
    respond_with(resource) do |format|
      format.pdf do
        filename = "bill_#{@bill.billed_on.to_s(:de)}.pdf"
        send_data render_to_string(:layout => false), {
            filename: filename,
            disposition: 'inline',
            type: :pdf
        }
      end
    end
  end

  private

  def collection
    @bills ||= end_of_association_chain.by_most_recent
  end

  def resource_params
    params.require(:bill).permit(:billed_on, :number, :therapist_id, bill_items_attributes: [:event_id, :id, :_destroy])
  end
end
