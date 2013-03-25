class ClientsController < InheritedResources::Base

  def create
    create! { clients_path }
  end

  def update
    update! { clients_path }
  end

  def destroy
    if resource.events.any?
      redirect_to clients_path, alert: 'Client with events cannot be deleted'
    else
      destroy!
    end
  end

  private

  def resource_params
    params.require(:client).permit(:active, :first_name, :last_name, :therapist_list, :dob)
  end

end