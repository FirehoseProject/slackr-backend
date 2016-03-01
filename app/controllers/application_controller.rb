class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def api_user
    if params[:api_key].present?
      User.where(:api_key => params[:api_key]).first
    else
      nil
    end
  end

  def require_api_user
    if api_user.blank?
      render :text => "API User Not Found", :status => :unauthorized
    end
  end

  protected


end
