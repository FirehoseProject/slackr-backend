class ChatMessagesController < ApplicationController

  def create
    cm = ChatMessage.create(chat_message_params)
    render :json => cm
  end

  def index
    messages = ChatMessage.order(:id).all
    all_messages = []
    messages.each do |m|
      if all_messages.present? && all_messages.last[:user_id] == m.user_id
        all_messages.last[:messages] << m.body
      else
        all_messages << m.as_json.with_indifferent_access.slice(:user_id, :body, :nickname, :id).merge(:messages => [m.body], :time => m.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%I:%M %p"))
      end
    end
    render :json => all_messages
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:body, :user_id)
  end
end
