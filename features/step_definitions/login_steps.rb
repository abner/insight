Quando(/^eu informo meu login "(.*?)" e minha senha "(.*?)"$/) do |username, password|
  @current_user = FactoryGirl.create(:user,
    :username => username,
    :password => password)

  fill_in 'Username', with: username
  fill_in 'Senha', with: password
end


Então(/^Eu devo ser redirecionado a lista de Minhas Aplicações$/) do
  expect(page.has_content?('Minhas Aplicações')).to eq(true)
end

Dado(/^informe credencias erradas$/) do
  fill_in 'Username', with: 'joao'
  fill_in 'Senha', with: 'ninguem'
end

#
# Dado /^que eu tenha um usuario "([^\"]*)" com email "([^\"]*)" e senha "([^\"]*)"$/ do |username,email, password|
#   @user = RegisteredUser.new(:email => email,
#                    :username=>username,
#                    :password => password,
#                    :password_confirmation => password)
#    @user.save!
# end

Dado(/^que eu sou um usuário autenticado$/) do
  name = 'joao'
  email = 'joao@ninguem.com'
  password = 'ninguem'

  step %{que eu acesse a tela de login}
  #Dado %{que eu tenha um usuário "#{name}" com email "#{email}" e senha "#{password}"}
  step %{eu informo meu login "joao" e minha senha "ninguem"}
  step %{clico no botão "Login"}
  step %{Eu devo ser redirecionado a lista de Minhas Aplicações}
end
