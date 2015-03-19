
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

   config.before(:each, :js => true) do
     #DatabaseCleaner.strategy = :truncation
     FactoryGirl.reload
     #DatabaseCleaner.start
     #DataSetup.run!
   end

  #  config.before(:each) do
  #    DatabaseCleaner.strategy = :truncation
  #    DatabaseCleaner.start
  #    DataSetup.run!
  #  end
   #
  #  config.after(:each) do
  #    DatabaseCleaner.clean
  #    FactoryGirl.reload
  #  end

  config.around(:each) do |example|
   DatabaseCleaner.cleaning do
     DataSetup.run!
     example.run
   end
  end
end
