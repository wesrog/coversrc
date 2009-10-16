require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'zlib'
require 'coversrc'

set :haml, { :format => :html5 }

run Sinatra::Application
