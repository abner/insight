require_relative './base'
module PageObject
  class LoginPage < Base

    def page_url
      '/sign_in.registered_user'
    end

    def authenticate username, password
      unless check_path page_url
        visit_page
      end
      fill_in 'username', with: username
      fill_in 'password', with: password
      click_on 'Login'
      self
    end

    def detector_element_selector
      'form.form-signin'
    end

  end
end
