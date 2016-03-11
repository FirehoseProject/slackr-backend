class User < ActiveRecord::Base
  has_many :chat_messages
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :populate_gravatar_url
  before_create :populate_api_key
  validates :nickname, :presence => true

  def populate_gravatar_url
      self.gravatar_url = Gravatar.new(self.email).image_url(:d => 'http://i.imgur.com/UPWvbDz.jpg')
  end

  def populate_api_key
    self.api_key = SecureRandom.hex
  end

  def as_json(options={})
    super(options).merge(status: 'active')
  end
end
