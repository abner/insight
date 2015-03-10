# def wait_for_dom(timeout = Capybara.default_wait_time)
#   page.wait_until(timeout) do
#     uuid = SecureRandom.uuid.gsub '-', ''
#     page.find("body")
#     page.evaluate_script <<-EOS
#       jQuery(document).on('page:load', function(){
#         jQuery('body').append("<div id='#{uuid}'></div>");
#       });
#       //_.defer(function() {
#       //  $('body').append("<div id='#{uuid}'></div>");
#       //});
#     EOS
#     page.find("div[id='#{uuid}']")
#   end
# end
