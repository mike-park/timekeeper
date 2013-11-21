class PraxisBillsController < InheritedResources::Base

  def new
    unbilled_count = Bill.unbilled.count
    if unbilled_count == 0
      redirect_to praxis_bills_path, alert: t('praxis_bills.no_unbilled_therapist_bills',
                                              default: 'No unbilled therapist bills are available to select')
    else
      new!
    end
  end

  def create
    @praxis_bill = build_resource
    if @praxis_bill.bills.size == 0
      redirect_to praxis_bills_path, alert: t('praxis_bills.no_therapist_bills_selected',
                                              default: "Praxis bill was not created. No therapist bill was selected.")
      return
    end
    create!
  end

  private

  def collection
    @praxis_bills ||= end_of_association_chain.by_most_recent
  end

  private

  def resource_params
    params.require(:praxis_bill).permit(:billed_on, :number, :note, :bill_ids => [])
  end
end
