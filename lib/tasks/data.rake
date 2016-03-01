# bundle exec rake data:populate
namespace :data do
  desc "Populate Sample Data in the Application"
  task :populate => :environment do
    10.times do
      User.create(
        email: Faker::Internet.email,
        nickname: Faker::Internet.user_name,
        password: "password123",
        password_confirmation: "password123",
      )
    end

    ChatMessage.class_eval do
      # don't push to Firebase on test data import
      def push_to_firebase
      end
    end
    50.times do
      u = User.order("RANDOM()").first
      u.chat_messages.create(
        body: Faker::Lorem.sentence(rand(100), true, rand(20))
      )
    end

  end

end
