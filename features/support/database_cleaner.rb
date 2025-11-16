require 'database_cleaner-active_record'

Before do
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end
