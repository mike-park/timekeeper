class UsersController < InheritedResources::Base
  def create
    create! { users_path }
  end

  def update
    update! { users_path }
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to users_path, :notice => "Can't delete yourself."
    else
      destroy! { users_path }
    end
  end

  protected

  def collection
    @users ||= end_of_association_chain.by_name
  end

  def update_resource(object, attributes)
    if attributes[:password].blank?
      attributes.except!(:password, :password_confirmation)
    end
    object.update_attributes(attributes)
  end

  def resource_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :therapist_id, :role_ids => [])
  end
end