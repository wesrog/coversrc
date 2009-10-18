$: << File.join(File.dirname(__FILE__), 'lib')
require 'lastfm'
require 'discogs'

DISCOGS_API_KEY = '21862297af'
LASTFM_API_KEY = '667910e60f2e9eb583f722f61dc01aab'

get '/' do
  if params[:user]
    redirect "/#{params[:user]}"
  end
  haml :index
end

get '/coversrc.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :coversrc
end

get %r{^/([\w\-/]+)?} do |user|
  @user = User.new(user)
  @recent_tracks = @user.recent_tracks
  @search = DiscogsSearch.new(@user.lp_artist, @user.lp_track)

  if ENV['RACK_ENV'] == 'production'
    headers['Cache-Control'] = 'public, max-age=60'
    etag @recent_tracks.to_etag
  end
  
  unless @user.recent_tracks.empty?
    haml :user
  else
    haml :index
  end
end

helpers do
  def tag_link(tag)
    %{<a href="http://www.last.fm/tag/#{tag}">#{tag}</a>}
  end

  def artist_link(artist)
    
  end
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end
