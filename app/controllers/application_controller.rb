class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  protect_from_forgery
  before_filter :authenticate_user!

  # code from https://github.com/FineLinePrototyping/employee-training-tracker
  #rescue_from Exception, :with => :render_error if Rails.env.production?
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  #rescue_from ActionController::RoutingError, :with => :render_not_found
  #rescue_from ActionController::UnknownController, :with => :render_not_found
  #rescue_from AbstractController::ActionNotFound, :with => :render_not_found
  rescue_from CanCan::AccessDenied, with: :render_not_found

  def render_not_found(exception)
    Rails.logger.error("\n#{exception.class} (#{exception.message}):\n #{Rails.backtrace_cleaner.clean(exception.backtrace).join("\n ")}")
    render_error_according_to_format exception, '/404.html', 404
  end

  def render_error(exception)
    Rails.logger.error("\n#{exception.class} (#{exception.message}):\n #{Rails.backtrace_cleaner.clean(exception.backtrace).join("\n ")}")
    render_error_according_to_format exception, '/500.html', 500
  end

  def render_error_according_to_format(exception, page_to_display, status_to_return)
    error_hash = {type: exception.class.name, message: exception.message, stack_trace: Rails.backtrace_cleaner.clean(exception.backtrace).join("\n ") }

    respond_to do |format|
      format.html { redirect_to page_to_display }
      format.json { render json: {error_data: error_hash}, status: status_to_return }
    end
  end

  def printing?
    params[:print]
  end
  helper_method :printing?

end
