require 'digest'

class UserNotFound < StandardError; end
class ArtistNotFound < StandardError; end

module Lastfm
  class User
    attr_reader :name, :uri, :response

    def initialize(name)
      @name = name
      @uri = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=#{URI.encode(@name)}&api_key=#{LASTFM_API_KEY}"
      @response = open(@uri, 'User-Agent' => 'coversrc/1.0 +http://coversrc.com')
      @doc = Nokogiri::XML(@response).xpath('//track')
      raise UserNotFound if @doc.empty?
      @doc
    end

    def to_s
      name
    end

    def recent_tracks
      if tracks = @doc.xpath('//track')
        tracks
      else
        raise UserNotFound
      end
    end

    def last_played
      recent_tracks.first
    end

    def to_etag
      Digest::MD5.hexdigest(last_played)
    end

    def lp_artist
      raise UserNotFound unless last_played
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

    def now_playing
      "#{lp_artist} #{lp_track}"
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
      if doc['status'] == 'failed'
        raise ArtistNotFound
      else
        tags = doc.xpath('//tag/name')
        if tags.empty?
          []
        else
          tags[0..4]
        end
      end
    end
  end
end
