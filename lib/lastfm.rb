class RecentTracks

  def initialize(user)
    @user = user
    @tracks = get_recent_tracks
  end

  def tracks
    @tracks.xpath('//track')
  end

  def status
    (now_playing?) ? 'Now playing...' : 'Inactive...'
  end

  def last_played
    tracks.first
  end

  def last_played_artist
    last_played.xpath('artist').first.content
  end

  def last_played_track
    last_played.xpath('name').first.content
  end

  def images
    last_played.xpath('image')
  end

  def tags
    top_tags(last_played_artist).xpath('//tag/name')[0..4]
  end

  def now_playing?
    last_played['nowplaying'] == 'true'
  end

private
  
  def get_recent_tracks
    Nokogiri::XML(open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{@user}&api_key=#{LASTFM_API_KEY}"))
  end

  def top_tags(artist)
    Nokogiri::XML(open("http://ws.audioscrobbler.com/2.0/?method=artist.gettoptags&artist=#{URI.encode(artist)}&api_key=#{LASTFM_API_KEY}"))
  end

end
