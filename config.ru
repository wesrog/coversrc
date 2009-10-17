require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'coversrc'

set :haml, { :format => :html5 }
set :run, false

run Sinatra::Application
