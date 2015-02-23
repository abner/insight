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
    active true
    text "Feedback Text provided by application user"
    user_application

    factory :feedback_with_comment do
      active true
      text "Feedback Text provided by application user"
      user_application
      comments { [FactoryGirl.attributes_for(:comment)] }
    end
  end


factory :comment do
     text 'Comment 1'
     user
end

  # factory :comment1, :class => :comment do
  #   text 'Comment 1'
  #   user
  # end
  #
  # factory :comment2, :class => :comment do
  #   text 'Comment 2'
  #   user
  # end

end
