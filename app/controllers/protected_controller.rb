class ProtectedController < ApplicationController
  before_filter :authenticate_user!
  #after_action :verify_authorized

  def index
    render text: '<h1>Protected</h1>'
  end
end
