Quando(/^clico no botão "(.*?)"$/) do |botao|
  find_button(botao).click
end


Quando(/^clico no link "(.*?)"$/) do |botao|
  find_link(botao).click
end


Então(/^preencho o campo "(.*?)" com "(.*?)"$/) do |nome_campo, valor|
  fill_in nome_campo, with: valor
end

Então(/^vejo a mensagem de sucesso "(.*?)"$/) do |mensagem|
  expect(page).to have_selector('div.alert-success', text: mensagem)
end
