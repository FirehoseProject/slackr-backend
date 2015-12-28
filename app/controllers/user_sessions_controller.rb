class UserSessionsController < ApplicationController
  def create
    email = params[:user][:email]
    password = params[:user][:password]

    user = User.where(:email => email).first
    if user.present? && user.valid_password?(password)
      render :json => user
    else
      render :json => {:errors => {:email => ['Unable to authenticate']}}, :status => :unprocessable_entity
    end
  end
end
