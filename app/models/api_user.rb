class ApiUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :populate_api_keys
  has_many :users
  has_many :chat_messages
  after_create :create_sandbox_message

  def populate_api_keys
    self.api_key = SecureRandom.hex(10)
    self.test_api_key = SecureRandom.hex(10)
  end

  def self.mode_and_user(api_key)
    user = ApiUser.where("api_key=? OR test_api_key=?", api_key, api_key).first
    mode = api_key == user.api_key ? :production : :test
    return [mode, user]
  end

  def create_sandbox_message

    5.times do
      self.users.create(
        email: Faker::Internet.email,
        nickname: Faker::Internet.user_name,
        password: "password123",
        password_confirmation: "password123",
        :mode => 'test'
      )
    end

    15.times do
      u = User.order("RANDOM()").first
      self.chat_messages.create(
        body: Faker::Lorem.sentence(rand(100), true, rand(20)),
        user_id: u.id,
        :mode => 'test',
        :skip_firebase => true
      )
    end


  end
end
