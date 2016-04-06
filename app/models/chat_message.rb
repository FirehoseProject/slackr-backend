class ChatMessage < ActiveRecord::Base
  belongs_to :user
  after_create :push_to_firebase
  belongs_to :api_user

  def as_json(options={})
    super(options).except("mode").merge("nickname" => self.user.try(:nickname), "avatar_url" => self.user.try(:gravatar_url))
  end

  def api_user_key
    if self.mode == 'test'
      return self.api_user.test_api_key
    else
      return self.api_user.api_key
    end
  end

  private
  def push_to_firebase
     FIREBASE.push("#{api_user_key}/messages", self.as_json)
  end
end
