require_relative './base'
module PageObject
  class FeedbackTargetIndexPage < Base
    def page_url
      '/feedback_targets'
    end

    def targets_list_selector
      "table#targets_list"
    end

    def assert_lists_targets

    end

    def verify_destroy_success_message
      verify_success_message I18n.t('User application removed successfully!')
    end

    def popover_selector
      "div.popover.fade"
    end

    def popover_text_selector
      "#{popover_selector} div.popover-content p"
    end

    def confirm_destroy
      within popover_selector do
        find('a', text: I18n.t('alertify.OK'))
        click_on I18n.t('alertify.OK')
      end
    end

    def cancel_destroy
      within popover_selector do
        click_on I18n.t('alertify.Cancel')
      end
    end

    def assert_destroy_popover_visible
      has_selector?(popover_text_selector, text: I18n.t('feedback_target.confirmation_question'), visible: true)
    end

    def assert_has_target_listed target_name
      find_target_on_list target_name
    end

    def click_edit_target target_name
      within find_target_on_list(target_name).parent do
        click_on I18n.t('Edit')
      end
    end

    def click_destroy_target target_name
      within find_target_on_list(target_name).parent do
        click_on I18n.t('Destroy')
      end
    end

    def click_target target_name
      within find_target_on_list(target_name) do
        click_on target_name
      end
    end

    def run
      yield self if block_given?
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
