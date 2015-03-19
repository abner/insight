require 'rails_helper'

feature 'Login', js: true do

  background do
    FactoryGirl.create(:registered_user, :username=> 'joao', :password => 'ninguem')
  end

  # using page objects as refered in this article
  # https://teamgaslight.com/blog/6-ways-to-remove-pain-from-feature-testing-in-ruby-on-rails
  # doc/6-ways-to-remove-pain-from-feature-testing-in-ruby-on-rails.pdf
  # the objective is not need to use cucumber to test site navigational features

  let(:login_page) { PageObject::LoginPage.new }
  let(:feedback_target_page) { PageObject::FeedbackTargetIndexPage.new }


  scenario 'authenticate with registered user' do
    login_page.visit_page do |p|
      p.authenticate 'joao', 'ninguem'
      p.assert_content_on_page!('Minhas Aplicações')
    end
  end

  scenario 'user cannot access protected page if not logged' do
    feedback_target_page.visit_page
    login_page.assert_on_page!
  end

  scenario 'login fails with invalid credentials' do
    login_page.visit_page do |p|
      p.authenticate 'not_registered', '1234'
      p.assert_content_on_page!('Erro na autenticação. Verifique')
    end
  end

  # scenario 'they see the login page', js: true do
  #   visit '/feedback_targets'
  #   expect(current_path).to eq('/')
  #   expect(find('form.form-signin')).to have_button('Login')
  # end
  #
  # scenario 'trying login with invalid credentials' do
  #   visit '/sign_in.registered_user'
  #   fill_in 'Username', with: 'user'
  #   fill_in 'Password', with: 'password'
  #   click_button 'Login'
  #   expect(page.has_content?('Erro na autenticação. Verifique se o nome de usuário (CPF) ou senha estão corretos')).to eq(true)
  # end
  #
  # scenario 'login with valid credentials', js: true do
  #   visit '/sign_in.registered_user'
  #   fill_in 'Username', with: 'joao'
  #   fill_in 'Password', with: 'ninguem'
  #   click_button 'Login'
  #   expect(page.has_content?('Minhas Aplicações')).to eq(true)
  #   click_link 'joao'
  #   # render page png (only works when js: true)
  #   #render_page('feedback_after_login')
  # end
end
