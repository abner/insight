Entao(/^Eu devo ver a listagem com meus Feedback Targets$/) do
  expect(page).to have_content(I18n.translate('feedback_target.page_title.index'))
end
