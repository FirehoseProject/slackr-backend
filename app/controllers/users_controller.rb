class UsersController < ApplicationController
  def index
    mode_and_user = ApiUser.mode_and_user(params[:api_user_key])
    mode = mode_and_user[0]
    api_user = mode_and_user[1]

    render :json => api_user.users.where(:mode => mode)
  end
  def create
    mode_and_user = ApiUser.mode_and_user(params[:api_user_key])
    mode = mode_and_user[0]
    api_user = mode_and_user[1]

    user = api_user.users.create(user_params.merge(:mode => mode))
    if user.valid?
       render :json => user
    else
       render :json => {:errors => user.errors.as_json }, :status => :unprocessable_entity
    end
  end

  private

  def user_params
    return {} if params[:user].blank?
    params.require(:user).permit(:nickname, :email, :password)
  end
end
