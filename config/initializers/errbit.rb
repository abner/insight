Airbrake.configure do |config|
  config.api_key = 'e6405ab36338cc78390899f84c455907'
  config.host    = 'localhost'
  config.port    = 3031
  config.secure  = config.port == 443

  config.development_environments = []
end
