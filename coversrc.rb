$: << File.join(File.dirname(__FILE__), 'lib')
require 'lastfm'
require 'discogs'

configure do
  if production?
    DISCOGS_API_KEY = ENV['DISCOGS_API_KEY'] 
    LASTFM_API_KEY = ENV['LASTFM_API_KEY']
  else
    c = YAML.load_file('config.yml')
    DISCOGS_API_KEY = c['config']['discogs_api_key']
    LASTFM_API_KEY = c['config']['lastfm_api_key']
  end
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
    user = request.cookies['coversrc_user']
    @search = Discogs::Search.new(user)
    @user = Lastfm::User.new(user)
    #etag Digest::MD5.hexdigest(@user.now_playing) if production?
    haml :discogs, :layout => false
  rescue OpenURI::HTTPError
    haml :error, :layout => false
  end
end

get '/release/:release_id' do
  haml :release, :layout => false
end

get %r{^/([\w\-/]+)?} do |user|
  begin
    @user = Lastfm::User.new(user)
    @artist = Lastfm::Artist.new(@user.lp_artist)

    #etag @user.to_etag if production?
    response.set_cookie 'coversrc_user', user

    haml :user
  rescue UserNotFound
    @user = nil
    haml '%p User not found'
  end
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
