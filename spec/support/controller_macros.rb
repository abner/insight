module ControllerMacros
  # def login_admin
  #   before(:each) do
  #     @request.env["devise.mapping"] = Devise.mappings[:admin]
  #     sign_in FactoryGirl.create(:admin) # Using factory girl as an example
  #   end
  # end

  def login_expresso_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:expresso_user]
      user = FactoryGirl.create(:expresso_user)
      #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:registered_user]
      user = FactoryGirl.create(:registered_user)
      #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end
end

RSpec.configure do |config|
  config.extend ControllerMacros, :type => :controller
end
