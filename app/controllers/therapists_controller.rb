class TherapistsController < InheritedResources::Base

  def create
    create! { therapists_path }
  end

  def update
    update! { therapists_path }
  end

  def destroy
    destroy! { therapists_path }
  end

  private

  def resource_params
    params.require(:therapist).permit(:first_name, :last_name, :abbrv, :category, :bank, :blz, :konto_nr,
                                      :phone, :send_reminders)
  end
end