class ChatMessage < ActiveRecord::Base
  belongs_to :user
  after_create :push_to_firebase

  def as_json(options={})
    super(options).merge("nickname" => self.user.try(:nickname))
  end

  def push_to_firebase
     FIREBASE.push("messages", self.as_json)
  end
end
