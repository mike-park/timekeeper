class EventCategoryPricesController < InheritedResources::Base

  def create
    create! { event_category_prices_path }
  end

  def update
    update! { event_category_prices_path }
  end

  private

  def collection
    @event_category_prices ||= end_of_association_chain.by_most_recent
  end

  def resource_params
    params.require(:event_category_price).permit(:title, :event_category_id, :price, :therapist_list)
  end
end
