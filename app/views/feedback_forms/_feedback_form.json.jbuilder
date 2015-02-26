json.id feedback_form.id.to_s
json.name feedback_form.name
json.screenshot_enabled feedback_form.screenshot_enabled || false
json.review_enabled feedback_form.review_enabled || false
json.set! :feedback_attributes do
  json.array! feedback_form.feedback_attributes
end
