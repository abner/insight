# using page objects as refered in this article
# https://teamgaslight.com/blog/6-ways-to-remove-pain-from-feature-testing-in-ruby-on-rails
# doc/6-ways-to-remove-pain-from-feature-testing-in-ruby-on-rails.pdf
# the objective is not need to use cucumber to test site navigational features

module PageObject
  class Base

    include Capybara::DSL


    def visit_page
      raise 'page_url missing' if page_url.nil?
      visit page_url
      if block_given?
        yield self
      else
        return self
      end
    end

    def page_url
      raise 'Not implemented'
    end

    def detector_element_selector
      raise 'Not implemented'
    end

    def verify_success_message message
      if ! has_selector?('div.alert-success', text: message)
        raise "Success message #{message} is missing"
      end
    end


    def is_current_page?
      current_path.eql? page_url
    end

    def check_path path_to_check
      /#{Regexp.escape(path_to_check)}/.match current_path
    end

    def check_path! path_to_check
       return true if check_path(path_to_check)
       raise "Expected to be at #{path_to_check} but currently on #{current_path}"
    end

    def assert_on_page!
      unless page.has_selector?(detector_element_selector)
        error_msg = "Expected to be on page #{self.class.name}"
        raise PageExpectationError.new(error_msg)
      end
    end

    def assert_content_on_page!(content, selector='body')
      msg_without_selector = "Expected page #{self.class.name} to have content \"#{content}\""
      msg_with_selector = "#{msg_without_selector} on selecor #{selector}"
      within selector do
        unless page.has_content?(content)
          error_msg = msg_with_selector unless 'body'.eql?(selector)
          raise PageExpectationError.new(error_msg)
        end
      end
    end
  end
end
