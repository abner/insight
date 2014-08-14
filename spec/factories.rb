FactoryGirl.define do
  factory :user, :aliases => [:owner] do
    username { "user-#{SecureRandom.hex(4)}" }
    email { "#{username}@dominio.com.br" }

  end

  factory :project do
    name { "SISCOAF #{SecureRandom.hex(4)}" }
    owner
  end

  factory :feedback do
    datetime { DateTime.now }
    project
  end
end
