FactoryGirl.define do
  factory :registered_user, :aliases => [:owner, :user, :assignee, 'usuário'] do
    username { "user-#{SecureRandom.hex(4)}" }
    email { "#{username}@dominio.com.br" }

  end

  factory :expresso_user do
    username { "user-#{SecureRandom.hex(4)}" }
    email { "#{username}@dominio.com.br" }
    json_key 'json_key'
    tine_key 'tine_key'
    name 'Ze Tony'
  end

  factory :ldap_user do
    username { "user-#{SecureRandom.hex(4)}" }
    email { "#{username}@dominio.com.br" }

  end

  factory :feedback_target do
    name { "SISCOAF #{SecureRandom.hex(4)}" }
    owner
  end


  factory :feedback_form do
    name 'Form novo'
    feedback_target
    description_columns ['relato']
    feedback_attributes { [FactoryGirl.build(:relato_attribute)] }
  end

  factory :relato_attribute, class: FeedbackAttribute do
    name 'relato'
    display_label 'Relato'
    type { FeedbackAttributeType.find_by(name: 'Textarea') }
  end

  factory :state_transition do
    state  'some_state'
    action 'some_action'
    result_state 'some_result_state'
  end

  factory :feedback_attribute, class: FeedbackAttribute do
    name 'attribute'
    display_label 'attribute label'
    type { FeedbackAttributeType.find_by(name: 'Textarea') }
  end

  factory :feedback_attribute_template do
    name 'attribute_name'
    display_label 'display_label'
    type { FeedbackAttributeType.find_by(name: 'Textarea') }
  end
  #
  # factory :textarea_type, class: FeedbackAttributeType, :aliases => [:type]  do
  #   name 'Textarea'
  #   description 'Textarea field'
  # end

  factory :feedback do
    active true
    text "Feedback Text provided by application user"
    feedback_form
    factory :feedback_with_comment do
      active true
      text "Feedback Text provided by application user"
      feedback_form
      comments { [FactoryGirl.attributes_for(:comment)] }
    end
    factory :feedback_with_assignee do
      assignee
    end
    factory :feedback_archived do
      active false
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
