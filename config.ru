require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'coversrc'

set :haml, { :format => :html5 }
set :run, false
set :environment, :production
#set :environment, :development

run Sinatra::Application
