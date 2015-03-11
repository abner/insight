Dado(/^que eu acesse a tela de login$/) do
  visit '/sign_in.registered_user'
end

Quando(/^eu informo meu login "(.*?)" e minha senha "(.*?)"$/) do |username, password|
  @current_user = FactoryGirl.create(:user,
    :username => username,
    :password => password)

  fill_in 'Username', with: username
  fill_in 'Senha', with: password
end

Quando(/^clico "(.*?)"$/) do |botao|
  find_button(botao).click
end

Então(/^Eu devo ser redirecionado a lista de Minhas Aplicações$/) do
  expect(page.has_content?('Minhas Aplicações')).to eq(true)
end

Dado(/^informe credencias erradas$/) do
  fill_in 'Username', with: 'joao'
  fill_in 'Senha', with: 'ninguem'
end
