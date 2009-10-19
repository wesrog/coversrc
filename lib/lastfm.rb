require 'digest'

class User
  def initialize(user)
    @user = user
    @recent_tracks = Nokogiri::XML(open("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{@user}&api_key=#{LASTFM_API_KEY}"))
  end

  def name
    @user
  end

  def to_s
    name
  end

  def recent_tracks
    @recent_tracks.xpath('//track')
  end

  def to_etag
    Digest::MD5.hexdigest(last_played)
  end

  def status
    (now_playing?) ? 'Now playing...' : 'Inactive...'
  end

  def last_played
    recent_tracks.first
  end

  def lp_artist
    last_played.xpath('artist').first.content
  end

  def lp_track
    last_played.xpath('name').first.content
  end

  def images
    last_played.xpath('image')
  end

  def now_playing?
    last_played['nowplaying'] == 'true'
  end
  
end

class Artist
  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end

  def top_tags
    doc = Nokogiri::XML(open("http://ws.audioscrobbler.com/2.0/?method=artist.gettoptags&artist=#{URI.encode(@name)}&api_key=#{LASTFM_API_KEY}"))
    doc.xpath('//tag/name')[0..4]
  end
end
