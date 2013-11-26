class BillsController < InheritedResources::Base
  belongs_to :therapist, optional: true
  respond_to :pdf, :html

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
end
