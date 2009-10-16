$: << File.join(File.dirname(__FILE__), 'lib')
require 'lastfm'

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
  @user = user
  @tracks = RecentTracks.new(@user)

  if @tracks
    haml :user
  else
    'not found'
  end
end

