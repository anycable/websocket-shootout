# Load the Rails application.
require_relative 'application'

require 'anycable-rails' if ENV['USE_ANYCABLE']
require_relative '../lib/actioncable_patch' if ENV['PATCH']
# Initialize the Rails application.
Rails.application.initialize!
