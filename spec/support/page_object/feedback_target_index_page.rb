require_relative './base'
module PageObject
  class FeedbackTargetIndexPage < Base
    def page_url
      '/feedback_targets'
    end

    def targets_list_selector
      "table#targets_list"
    end

    def check_lists_targets

    end

    def self.page_messages
      {
        destroy_success: I18n.t('User application removed successfully!'),
        targets_empty: I18n.t('No application registered yet')
      }
    end

    def page_messages
      FeedbackTargetIndexPage.page_messages
    end

    def check_success_destroy_message_visible
      check_success_message_visible(:destroy_success)
    end

    def check_success_message_visible message
      if page_messages[message].nil?  or message.blank?
        error_msg = "Page message #{message} not defined on #{self.class.name}"
        raise PageExpectationError.new(error_msg)
      end
      verify_success_message page_messages[message]
    end

    def popover_selector
      "div.popover.fade"
    end

    def popover_text_selector
      "#{popover_selector} div.popover-content p"
    end

    def click_on_confirm_destroy
      within popover_selector do
        find('a', text: I18n.t('alertify.OK'))
        click_on I18n.t('alertify.OK')
      end
    end

    def click_on_cancel_destroy
      within popover_selector do
        find('a', text: I18n.t('alertify.Cancel'))
        click_on I18n.t('alertify.Cancel')
      end
    end

    def check_destroy_popover_visible
      self.check_destroy_popover(true)
    end

    def check_no_destroy_popover_visible
      self.check_destroy_popover(false)
    end

    def check_destroy_popover(visible = true)
      if visible
        has_selector?(popover_text_selector, text: I18n.t('feedback_target.confirmation_question'), visible: true)
      else
        has_no_selector?(popover_text_selector, text: I18n.t('feedback_target.confirmation_question'), visible: true)
      end
    end

    def check_target_listed target_name
      find_target_on_list target_name
    end

    def check_target_not_listed target_name
      begin
        within find_targets_list_element do
          has_no_selector?('tr td', text: target_name)
        end
      rescue Capybara::ElementNotFound => e
        # if there is no targets on list,
        # the table is not rendered
        # checking message about that in the page
        has_content? page_messages[:targets_empty]
      end
    end

    def click_on_edit_target target_name
      within find_target_on_list(target_name).parent do
        click_on I18n.t('Edit')
      end
    end

    def click_on_destroy_target target_name
      within find_target_on_list(target_name).parent do
        click_on I18n.t('Destroy')
      end
    end

    def click_on_target_name target_name
      within find_target_on_list(target_name) do
        click_on target_name
      end
    end

private
    def find_targets_list_element
      find(targets_list_selector)
    end

    def find_target_on_list target_name
      within find_targets_list_element do
        find('tr td', text: target_name)
      end
    end

  end
end
