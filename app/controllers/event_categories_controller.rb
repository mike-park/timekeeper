class EventCategoriesController < InheritedResources::Base

  def create
    create! { event_categories_path }
  end

  def update
    update! { event_categories_path }
  end

  def destroy
    if resource.events.any?
      redirect_to event_categories_path, alert: 'Event category used by events cannot be deleted'
    else
      destroy!
    end
  end

  private

  def resource_params
    params.require(:event_category).permit(:active, :title, :abbrv, :sort_order, :color)
  end

end