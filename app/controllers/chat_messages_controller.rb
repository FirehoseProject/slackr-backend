class ChatMessagesController < ApplicationController
  before_action :require_api_user, :only => :create

  def create
    mode_and_user = ApiUser.mode_and_user(params[:api_user_key])
    mode = mode_and_user[0]
    api_user = mode_and_user[1]

    user = api_user.users.where(:api_key => params[:api_key]).first

    cm = user.chat_messages.create(chat_message_params.merge(:mode => mode, :api_user => api_user))
    if mode.to_s == user.mode.to_s && api_user.id == user.api_user.id
      render :json => cm
    else
      render :json => {errors: cm.errors}, status: :unprocessable_entity
    end
  end

  def index

    mode_and_user = ApiUser.mode_and_user(params[:api_user_key])
    mode = mode_and_user[0]
    api_user = mode_and_user[1]


    messages = api_user.chat_messages.order(:id).all
    all_messages = []
    messages.each do |m|
      if all_messages.present? && all_messages.last[:user_id] == m.user_id
        all_messages.last[:messages] << m.body
      else
        all_messages << m.as_json.with_indifferent_access.slice(:user_id, :body, :nickname, :id, :avatar_url).merge(:messages => [m.body], :time => m.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M %p"))
      end
    end
    render :json => all_messages
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:body, :user_id)
  end
end
