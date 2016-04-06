class ChatMessage < ActiveRecord::Base
  belongs_to :user
  after_create :push_to_firebase
  belongs_to :api_user

  validate :ensure_user_is_in_same_mode
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
  def ensure_user_is_in_same_mode
    if self.user && self.user.mode != self.mode || self.user.api_user_id != self.api_user_id
      self.errors.add(:public_key, "invalid permissions")
    end
  end
  def push_to_firebase
     FIREBASE.push("#{api_user_key}/messages", self.as_json)
  end
end
