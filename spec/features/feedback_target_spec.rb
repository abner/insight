#TODO refatorar para usar page objects
require 'rails_helper'
feature 'Feedback targets', js: true do

  background do
    I18n.locale = 'pt-BR'
    @user = FactoryGirl.create(:registered_user, :username=> 'joao', :password => 'ninguem')
    @feedback_targets = [FactoryGirl.create(:feedback_target, name: 'APP 1', :owner => @user)]
    sign_in_user 'joao', 'ninguem'
  end

  let(:feedback_target_page) { PageObject::FeedbackTargetIndexPage.new }

  context 'Visiting Index Page' do
    scenario 'user sees the feedback targets he owns' do
      feedback_target_page.visit_page do |page_object|
        page_object.check_target_listed(@feedback_targets.first.name)
      end
    end

    context 'user can destroy feedback target' do
      scenario 'feedback target will remove if confirmed' do
        feedback_target_page.visit_page do |page_object|
          page_object.check_target_listed(@feedback_targets.first.name)
          page_object.click_on_destroy_target(@feedback_targets.first.name)
          page_object.check_destroy_popover_visible
          page_object.click_on_confirm_destroy
          page_object.check_success_destroy_message_visible
          page_object.check_target_not_listed(@feedback_targets.first.name)
        end
      end

      scenario 'feedback target won\'t  be removed if not confirmed' do
        feedback_target_page.visit_page do |page_object|
          page_object.check_target_listed(@feedback_targets.first.name)
          page_object.click_on_destroy_target(@feedback_targets.first.name)
          page_object.check_destroy_popover_visible
          page_object.click_on_cancel_destroy
          page_object.check_no_destroy_popover_visible
          page_object.check_target_listed(@feedback_targets.first.name)
        end
      end
    end
  end

  context 'Members' do
    scenario 'add member' do
      new_user_1 = FactoryGirl.create(:user, :username => 'kenedy')
      new_user_2 = FactoryGirl.create(:user, :username => 'steph')
      feedback_target_page.visit_page do |index_page|
        index_page.click_on_target_name 'APP 1' do |show_page|
          show_page.assert_not_is_member! 'kenedy'
          show_page.add_team_member 'kenedy'
          show_page.assert_is_member! 'kenedy'
        end
      end
    end

    scenario 'remove member' do
      new_user_1 = FactoryGirl.create(:user, :username => 'kenedy')
      @feedback_targets.first.members << new_user_1
      visit feedback_targets_path
      find('table#targets_list').click_link 'APP 1'
      expect(page).to have_selector('#members_list li', 'kenedy')
      click_link I18n.t('remove_member')
      expect(page).not_to have_selector('#members_list li', 'kenedy')
    end

    scenario 'getting error on removing member' do
      allow_any_instance_of(FeedbackTarget).to receive(:remove_member).and_return(false)
      errors = ActiveModel::Errors.new(FeedbackTarget.new).tap {
        |e| e.add(:member, "não foi possível adicionar membro")
      }
      allow_any_instance_of(FeedbackTarget).to receive(:errors).and_return(errors)
      new_user_1 = FactoryGirl.create(:user, :username => 'kenedy')
      @feedback_targets.first.members << new_user_1
      visit feedback_targets_path
      find('table#targets_list').click_link 'APP 1'
      expect(page).to have_selector('#members_list li', 'kenedy')
      click_link I18n.t('remove_member')
      expect(page).to have_selector('div.alert-danger', I18n.t('alert_errors'))
      expect(page).to have_content('não foi possível adicionar membro')
    end

    scenario 'getting error o adding a member' do
      allow_any_instance_of(FeedbackTarget).to receive(:include_members).and_return(false)
      errors = ActiveModel::Errors.new(FeedbackTarget.new).tap {
        |e| e.add(:member,"não foi possível adicionar membro")
      }
      allow_any_instance_of(FeedbackTarget).to receive(:errors).and_return(errors)

      new_user_1 = FactoryGirl.create(:user, :username => 'kenedy')
      new_user_2 = FactoryGirl.create(:user, :username => 'steph')
      visit feedback_targets_path
      find('table#targets_list').click_link 'APP 1'

      expect(page).not_to have_selector('#members_list li', 'kenedy')

      find("li.select2-search-field input[type='text']").click
      find("li.select2-search-field input[type='text']").set('ke')
      find('li div.select2-result-label', text: 'kenedy').click

      expect(page).to have_selector('div.alert-danger', I18n.t('alert_errors'))
      expect(page).to have_content('não foi possível adicionar membro')
    end
  end
  #
  # context 'New Page' do
  #
  #   scenario 'register a new feedback target' do
  #     visit feedback_targets_path
  #     click_link 'Adicionar uma nova Aplicação'
  #
  #     expect(page).to have_content('Nova Aplicação')
  #     expect(current_path).to eq(new_feedback_target_path)
  #
  #     fill_in 'Nome', with: 'My new App'
  #     click_button 'Salvar'
  #
  #     expect(current_path).to eq(feedback_targets_path)
  #     expect(page).to have_selector('div.alert-success', text: 'Aplicação criada!')
  #     expect(page).to have_content('APP 1')
  #     expect(page).to have_content('My new App')
  #   end
  #
  #   scenario 'trying register target without name' do
  #     visit new_feedback_target_path
  #     click_button 'Salvar'
  #     expect(page).to have_content('não pode ser vazio')
  #     expect(page).to have_button('Salvar')
  #     #page!
  #   end
  # end
  #
  # context 'Edit Page' do
  #   scenario 'visit edit page' do
  #     visit feedback_targets_path
  #     click_link 'Alterar'
  #     expect(page).to have_content('Alterar Aplicação')
  #     expect(current_path).to eq(edit_feedback_target_path(@feedback_targets.first))
  #   end
  #
  #   scenario 'change feedback target' do
  #     visit feedback_targets_path
  #     click_link 'Alterar'
  #     expect(page).to have_content('Alterar Aplicação')
  #     fill_in 'Nome', with: 'New name for App 1'
  #     click_button 'Salvar'
  #     expect(page).to have_selector('div.alert-success', text: 'Aplicação alterada com sucesso!')
  #     within 'table#targets_list' do
  #       expect(page).to have_content('New name for App 1')
  #     end
  #   end
  #
  #   scenario 'try change feedback target with empty name' do
  #     visit feedback_targets_path
  #     click_link 'Alterar'
  #     expect(page).to have_content('Alterar Aplicação')
  #     fill_in 'Nome', with: ''
  #     click_button 'Salvar'
  #     expect(page).to have_content('não pode ser vazio')
  #     expect(page).to have_button('Salvar')
  #   end
  #
  #   scenario 'tyring to edit some one else target' do
  #     target_to_visit = FactoryGirl.create(:feedback_target)
  #     visit edit_feedback_target_path(target_to_visit)
  #     expect(page).to have_content('Algo de errado aconteceu Você tem certeza que deveria estar por aqui?')
  #     #expect(status_code).to eq(403)
  #   end
  # end
  #
  # context 'Show Page' do
  #   scenario 'visiting feedback show page' do
  #
  #
  #     visit feedback_targets_path
  #     find('table#targets_list').click_link 'APP 1'
  #     expect(page).to have_content('APP 1')
  #     expect(page).to have_content('Dados da Aplicação')
  #   end
  # end
end
