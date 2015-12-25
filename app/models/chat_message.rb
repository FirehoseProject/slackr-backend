class ChatMessage < ActiveRecord::Base
  belongs_to :user

  def as_json(options={})
    super(options).merge("nickname" => self.user.try(:nickname))
  end
end
