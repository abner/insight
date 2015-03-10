require 'rails_helper'
feature 'Feedback targets', js: true do

  background do
    @user = FactoryGirl.create(:registered_user, :username=> 'joao', :password => 'ninguem')
    @feedback_targets = [FactoryGirl.create(:feedback_target, name: 'APP 1', :owner => @user)]
    sign_in_user 'joao', 'ninguem'
  end

  scenario 'the feedback targets user owns are listed' do
    visit feedback_targets_path
    expect(page).to have_content(@feedback_targets.first.name)
  end

  scenario 'register a new feedback target' do
    visit feedback_targets_path
    click_link 'Adicionar uma nova Aplicação'
    expect(current_path).to eq(new_feedback_target_path)
    fill_in 'Nome', with: 'My new App'
    click_button 'Salvar'
    expect(current_path).to eq(feedback_targets_path)
    expect(page).to have_selector('div.alert-success', text: 'Aplicação criada!')
    expect(page).to have_content('APP 1')
    expect(page).to have_content('My new App')
  end

  scenario 'edit a feedback target' do
    visit feedback_targets_path
    click_link 'Alterar'
    expect(current_path).to eq(edit_feedback_target_path(@feedback_targets.first))
    #render_page('feedback_edit')
  end
end
