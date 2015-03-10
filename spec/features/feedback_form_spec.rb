require 'rails_helper'
feature 'Feedback forms', js: true do

  background do
    @user = FactoryGirl.create(:registered_user, :username=> 'joao', :password => 'ninguem')
    @feedback_targets = [FactoryGirl.create(:feedback_target, name: 'APP 1', :owner => @user)]
    @feedback_forms = @feedback_targets.first.feedback_forms
    sign_in_user 'joao', 'ninguem'
  end

  scenario 'list the target forms' do
    visit feedback_target_feedback_forms_path(@feedback_targets.first)
    render_page('list_forms')
    expect(page).to have_content(@feedback_forms.first.name)
  end

  scenario 'shows feedback form' do
    visit feedback_target_feedback_forms_path(@feedback_targets.first)
    click_link @feedback_forms.first.name
    expect(current_path).to eq(feedback_target_feedback_form_path(@feedback_targets.first, @feedback_forms.first))
  end

  scenario 'creates a new feedback form' do

  end

  scenario 'edit a feedback form' do
    visit feedback_target_feedback_forms_path(@feedback_targets.first)
    click_link 'Alterar'
    render_page('edit_feedback_form')
    #expect(page).to have_content(@feedback_forms.first.name)
  end
end
