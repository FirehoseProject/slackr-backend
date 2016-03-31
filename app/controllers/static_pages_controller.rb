class StaticPagesController < ApplicationController
  before_action :authenticate_api_user!, :only => [:test, :production]
  before_action :bounce_to_test, :only => [:index]


  def bounce_to_test
    redirect_to test_api_path if current_api_user.present?
  end
end
