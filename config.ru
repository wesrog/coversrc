require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'coversrc'

set :haml, { :format => :html5 }
set :run, false

run Sinatra::Application
