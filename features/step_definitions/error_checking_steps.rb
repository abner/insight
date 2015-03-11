Entao(/^vejo mensagem de erro "(.*?)"$/) do |msg|
  expect(page.has_selector?('div.alert-danger', text: msg)).to eq(true)
end
