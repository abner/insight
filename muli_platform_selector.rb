platforms :jruby do
  gem "activerecord-jdbcsqlite3-adapter"
end

platforms :mri do
  gem "sqlite3"
end