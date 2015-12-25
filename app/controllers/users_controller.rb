class UsersController < ApplicationController
  def index
    render :json => User.all
  end
  def create
    sleep(1)
    user = User.create(user_params)
    if user.valid?
       render :json => user
    else
	puts "ERROR!"
       render :json => {:errors => user.errors.as_json }, :status => :unprocessable_entity
    end
  end

  private

  def user_params
    return {} if params[:user].blank?
    params.require(:user).permit(:nickname, :email, :password)
  end
end
