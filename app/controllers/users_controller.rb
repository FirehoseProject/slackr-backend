class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    if user.valid?
       render :json => user
    else
       render :json => {:errors => user.errors.as_json }, :status => :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :email, :password)
  end
end
