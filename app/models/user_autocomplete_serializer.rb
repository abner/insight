class UserAutocompleteSerializer < ActiveModel::Serializer
  attributes :id, :username, :email

  def username
        object.username
  end

  def email
    object.email
  end

  def id
    object._id.to_s
  end
end
