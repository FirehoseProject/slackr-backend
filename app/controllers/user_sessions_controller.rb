class UserSessionsController < ApplicationController
  def create
    email = params[:user][:email]
    password = params[:user][:password]

    mode_and_user = ApiUser.mode_and_user(params[:api_user_key])
    mode = mode_and_user[0]
    api_user = mode_and_user[1]

    user = api_user.users.where(:email => email, :mode => mode).first
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
    mode_and_user = ApiUser.mode_and_user(params[:api_user_key])
    mode = mode_and_user[0]
    api_user = mode_and_user[1]

    user = api_user.users.where("api_key=?", params[:api_key]).first
    if user.present?
      user.update_attributes(:api_key => nil)
    end
    render :json => user
  end
end
