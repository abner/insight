module PageObject
  class FeedbackTargetShowPage < Base

    def initialize feedback_target_name
      @target_name = feedback_target_name
    end

    # overriding base method
    def detector_element_selector
      {css: 'h3.panel-title', text: I18n.t('Application Info')}
    end

    # overriding base method
    def page_url
      "/feedback_targets/#{@target_name}"
    end

    def assert_is_member! member_name
      unless page.has_no_selector?('#members_list li', text: member_name)
        error_msg = "#{member_name} was expected to be listed as member - #{self.class.name}"
        raise PageExpectationError.new(error_msg)
      end
    end

    def assert_not_is_member! member_name
      unless page.has_no_selector?('#members_list li', text: member_name)
        error_msg = "#{member_name} was not expected to be listed as member - #{self.class.name}"
        raise PageExpectationError.new(error_msg)
      end
    end

    def add_team_member member_name
      find("li.select2-search-field input[type='text']").click
      find("li.select2-search-field input[type='text']").set(member_name)
      find('li div.select2-result-label', text: 'kenedy').click
    end
  end
end
