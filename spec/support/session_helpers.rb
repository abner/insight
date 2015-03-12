module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit registered_user_sign_up_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Registrar'
    end

    def sign_in_user(username, password)
      visit new_session_path(:registered_user)
      fill_in 'Username', with: username
      fill_in 'Password', with: password
      click_button 'Login'
    end

    # def check_logged?
    #   ! get_me_the_cookie().nil?
    # end

  end
end

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
end
