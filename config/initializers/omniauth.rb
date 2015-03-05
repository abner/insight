OmniAuth.config.logger = Rails.logger

#Capture OMNIAUTH Failures in Development Mode
#http://bayendor.github.io/blog/2013/09/19/using-omniauth-in-development/
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :expressov3
end
