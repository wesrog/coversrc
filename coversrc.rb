$: << File.join(File.dirname(__FILE__), 'lib')
require 'rubygems'
require 'yaml'
require 'sinatra'
require 'haml'
require 'sass'
require 'nokogiri'
require 'open-uri'
require 'lastfm'
require 'discogs'

configure :production do
  DISCOGS_API_KEY = ENV['DISCOGS_API_KEY'] 
  LASTFM_API_KEY = ENV['LASTFM_API_KEY']
end

configure :test do
  keys = YAML.load_file('config.yml')['keys']
  DISCOGS_API_KEY = keys['discogs']
  LASTFM_API_KEY = keys['lastfm']
end

configure :development do
  keys = YAML.load_file('config.yml')['keys']
  DISCOGS_API_KEY = keys['discogs']
  LASTFM_API_KEY = keys['lastfm']
end

before do
  #headers['Cache-Control'] = 'public, max-age=60' if production?
end

get '/' do
  if params[:user]
    redirect "/#{params[:user]}"
  end
  haml :index
end

get '/coversrc.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :coversrc
end

get '/discogs' do
  begin
    @user = Lastfm::User.new(request.cookies['coversrc_user'])
    @search = Search.new(@user.now_playing)
    #etag Digest::MD5.hexdigest(@user.now_playing) if production?
    haml :discogs, :layout => false
  rescue UserNotFound
    haml '%p User not found', :layout => false
  rescue Exception => e
    @e = e
    haml :error, :layout => false
  end
end

get '/lastfm' do
  begin
    @user = Lastfm::User.new(request.cookies['coversrc_user'])
    @artist = Lastfm::Artist.new(@user.lp_artist)

    #etag @user.to_etag if production?
    haml :lastfm, :layout => false
  rescue UserNotFound
    response.set_cookie 'coversrc_user', nil
    haml '%p User not found', :layout => false
    status 404
  end
end

get '/release/:release_id' do
  haml :release, :layout => false
end

get %r{^/([\w\-/]+)?} do |user|
  @user = user
  response.set_cookie 'coversrc_user', @user
  haml :user
end

helpers do
  def tag_link(tag)
    %{<a href="http://www.last.fm/tag/#{tag}">#{tag}</a>}
  end

  def artist_link(artist)
    
  end

  def pluralize(count, word)
    count == 1 ? "#{count} #{word}" : "#{count} #{word}s"
  end

  def production?
    ENV['RACK_ENV'] == 'production'
  end
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end
