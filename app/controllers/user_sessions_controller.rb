class UserSessionsController < ApplicationController
  def create
    email = params[:user][:email]
    password = params[:user][:password]

    user = User.where(:email => email).first
    if user.present? && user.valid_password?(password)
      if user.api_key.blank?
        user.populate_api_key
        user.save
      end
      render :json => user
    else
      render :json => {:errors => {:email => ['Unable to authenticate']}}, :status => :unprocessable_entity
    end
  end

  def destroy
    user = api_user
    if user.present?
      user.update_attributes(:api_key => nil)
    end
    render :json => user
  end
end
