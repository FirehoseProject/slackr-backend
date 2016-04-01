class User < ActiveRecord::Base
  has_many :chat_messages
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  before_save :populate_gravatar_url
  before_create :populate_api_key
  validates :nickname, :presence => true
  validates :email, :uniqueness => {:scope => [:api_user_id, :mode] }
  belongs_to :api_user

  def populate_gravatar_url
      self.gravatar_url = Gravatar.new(self.email).image_url(:d => 'http://i.imgur.com/UPWvbDz.jpg')
  end

  def populate_api_key
    self.api_key = SecureRandom.hex
  end

  def as_json(options={})
    json = super(options).merge(status: 'active').except("mode", "api_user_id")
    json = json.except("api_key") if options.with_indifferent_access[:include_api_key] == false
    json
  end
end
