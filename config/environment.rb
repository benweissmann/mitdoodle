ENV['RAILS_RELATIVE_URL_ROOT'] = "/mitdoodle"

# Uncomment below to put Rails into production mode
# ENV['RAILS_ENV'] ||= 'production'
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mitdoodle::Application.initialize!
