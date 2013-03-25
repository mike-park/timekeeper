class BillPresenter
  attr_reader :service_presenter
  delegate :services, :clients, :service_names, :service_abbrvs, :to => :service_presenter

  def initialize(bill)
    @bill = bill
    @service_presenter = ServicesPresenter.new(@bill.bill_items)
  end

  def billed_on
    @bill.billed_on.to_s(:de)
  end
end
