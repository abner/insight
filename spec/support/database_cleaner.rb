
RSpec.configure do |config|


  config.before(:suite) do
    begin
      DatabaseCleaner.clean_with(:truncation)

      DatabaseCleaner.start
      #FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.around(:each) do |example|
   DatabaseCleaner.cleaning do
    DataSetup.run!
    example.run
   end
  end
end
