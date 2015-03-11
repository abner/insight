require 'rails_helper'
feature 'User not logged' do

  background do
    FactoryGirl.create(:registered_user, :username=> 'joao', :password => 'ninguem')
  end

  scenario 'they see the login page', js: true do
    visit '/feedback_targets'
    expect(current_path).to eq('/')
    expect(find('form.form-signin')).to have_button('Login')
  end

  scenario 'trying login with invalid credentials' do
    visit '/sign_in.registered_user'
    fill_in 'Username', with: 'user'
    fill_in 'Password', with: 'password'
    click_button 'Login'
    expect(page.has_content?('Erro na autenticação. Verifique se o nome de usuário (CPF) ou senha estão corretos')).to eq(true)
  end

  scenario 'login with valid credentials', js: true do
    visit '/sign_in.registered_user'
    fill_in 'Username', with: 'joao'
    fill_in 'Password', with: 'ninguem'
    click_button 'Login'
    expect(page.has_content?('Minhas Aplicações')).to eq(true)
    click_link 'joao'
    # render page png (only works when js: true)
    #render_page('feedback_after_login')
  end
end
