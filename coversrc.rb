$: << File.join(File.dirname(__FILE__), 'lib')
require 'lastfm'

DISCOGS_API_KEY = '21862297af'
LASTFM_API_KEY = '667910e60f2e9eb583f722f61dc01aab'

get %r{^/([\w\-/]+)?$} do |user|
  @user = user || 'arniemg'
  @tracks = RecentTracks.new(@user)

  if @tracks
    haml :index
  else
    'not found'
  end
end

