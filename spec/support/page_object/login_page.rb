require_relative './base'
module PageObject
  class LoginPage < Base

    # overriding base method
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

    # overriding base method
    def detector_element_selector
      {css: 'form.form-signin'}
    end

  end
end
