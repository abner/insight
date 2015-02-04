require 'active_model'
class UsersController < ProtectedController

  def autocomplete
    @users = User.by_username(params[:username])
    render json: @users, :root => false, :each_serializer => UserAutocompleteSerializer
  end

end
