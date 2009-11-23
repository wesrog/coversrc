load 'coversrc.rb'

set :haml, { :format => :html5 }
set :run, false

run Sinatra::Application
