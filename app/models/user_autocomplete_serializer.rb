class UserAutocompleteSerializer < ActiveModel::Serializer
  attributes :id, :username

  def username
        object.username
  end


  def id
    object._id.to_s
  end
end
