FactoryGirl.define do
  factory :registered_user, :aliases => [:owner, :user] do
    username { "user-#{SecureRandom.hex(4)}" }
    email { "#{username}@dominio.com.br" }

  end

  factory :feedback_target do
    name { "SISCOAF #{SecureRandom.hex(4)}" }
    owner
  end


  factory :feedback_form do
    name 'Relato ou Sugestão'
    feedback_target
    description_columns ['relato']
    feedback_attributes { [FactoryGirl.attributes_for(:relato_attribute)] }
  end

  factory :relato_attribute, class: FeedbackAttribute do
    name 'relato'
    display_label 'Relato'
    type { [FactoryGirl.attributes_for(:textarea_type)] }
  end

  factory :feedback_attribute, class: FeedbackAttribute do
    name 'attribute'
    display_label 'attribute label'
    type { [FactoryGirl.attributes_for(:textarea_type)] }
  end

  factory :feedback_attribute_template do
    name 'attribute_name'
    display_label 'display_label'
    type { [FactoryGirl.attributes_for(:textarea_type)] }
  end

  factory :textarea_type, class: FeedbackAttributeType do
    name 'Textarea'
  end

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
  end


factory :comment do
     text 'Comment 1'
     registered_user
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
