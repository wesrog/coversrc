require File.join(File.dirname(__FILE__), '..', 'coversrc.rb')

require 'spec'
require 'spec/interop/test'
require 'spec/autorun'
require 'rack/test'

Test::Unit::TestCase.send :include, Rack::Test::Methods

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end
