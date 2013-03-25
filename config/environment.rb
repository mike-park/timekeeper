# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Timekeeper::Application.initialize!

# correct queue time logging
Timekeeper::Application.middleware.insert(0, QueueTimeLogger)
