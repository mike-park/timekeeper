class Api::UsersController < ApplicationController
  respond_to :json
  inherit_resources

  def show
    if params[:id] == 'current'
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    # disable use of Last-Modified header that comes from user.update_at
    # we embed other records that might have been updated after user.updated_at
    # see Responders::HttpCacheResponder.
    show!(http_cache: false)
  end
end
