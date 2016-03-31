class ApiUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :populate_api_keys
  has_many :users
 def populate_api_keys
    self.api_key = SecureRandom.hex(10)
    self.test_api_key = SecureRandom.hex(10)
  end

  def self.mode_and_user(api_key)
    user = ApiUser.where("api_key=? OR test_api_key=?", api_key, api_key).first
    mode = api_key == user.api_key ? :production : :test
    return [mode, user]
  end

end
