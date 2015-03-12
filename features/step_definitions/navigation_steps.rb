Dado(/^que eu acesse a tela de login$/) do
  visit '/sign_in.registered_user'
end


E(/^eu acesse a tela Feedback Targets$/) do
  visit '/feedback_targets'
end

Então /^eu vejo a tela "(.*?)"$/ do |tela|
  expect(page).to have_content(tela)
end
