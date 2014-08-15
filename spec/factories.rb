FactoryGirl.define do
  factory :user, :aliases => [:owner] do
    username { "user-#{SecureRandom.hex(4)}" }
    email { "#{username}@dominio.com.br" }

  end

  factory :user_application do
    name { "SISCOAF #{SecureRandom.hex(4)}" }
    owner
  end

  factory :feedback do
    text "Feedback Text provided by application user"
    user_application
  end
end
