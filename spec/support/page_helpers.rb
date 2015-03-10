module Features
  module PageHelpers

    def screenshot_path
      Rails.application.config.integration_test_render_dir
    end

    def render_page(name)#, force = false)
      ensure_dir_exists!
      #if force || (ENV['RENDER_SCREENSHOTS'] == 'YES')
      if page.driver.respond_to?(:render)
        path = File.join Rails.application.config.integration_test_render_dir, "#{name}.png"
        page.driver.render(path, full: true)
        puts "Screenshot saved on #{path}"
      else
        raise "Screenshot not rendered (it is not a js feature or driver does not support render )"
      end
    end

    def page!
      save_and_open_page
      sleep 1 # aguarda navegador renderizar a página
    end

    def ensure_dir_exists!
      FileUtils.mkdir_p screenshot_path unless Dir.exists? screenshot_path
    end

    def page!
      save_and_open_screenshot
    end
  end
end

RSpec.configure do |config|
  config.include Features::PageHelpers, type: :feature
end
