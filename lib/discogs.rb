require 'zlib'

module Gzipper
  def gzip_read(uri)
    req = open(uri, 'Accept-Encoding' => 'gzip', 'User-Agent' => 'coversrc')
    gzip = Zlib::GzipReader.new(req)
    Nokogiri::XML(gzip)
  rescue Zlib::GzipFile::Error
    # TODO not sure why this happens and the best way to handle the error
    Nokogiri::XML::Document.new
  end
end

module Discogs
  class Release
    include Gzipper

    def initialize(id)
      @id = id
      uri = "http://www.discogs.com/release/#{@id}?f=xml&api_key=#{DISCOGS_API_KEY}"
      @release =  gzip_read(uri)
    end

    def id
      @id
    end

    def release
      @release
    end

    def title
      @release.xpath('//title').first.content
    end

    def image
      if uri = @release.xpath('//image').first
        uri['uri']
      end
    end

    def format
      @release.xpath('//format').first['name']
    end

    def image_count
      @release.xpath('//image').size
    end

    def genres
      @release.xpath('//genre')
    end

    def styles
      @release.xpath('//style')
    end

  end

  class Search
    include Gzipper

    def initialize(user)
      @user = Lastfm::User.new(user)
      @query = URI.encode(@user.now_playing)
      @uri = "http://www.discogs.com/search?type=all&q=#{@query}&f=xml&api_key=#{DISCOGS_API_KEY}"
      @results = gzip_read(@uri)
    end

    def uri
      @uri
    end

    def results
      @results.xpath('//result').map { |r| Discogs::Release.new(r.xpath('uri').first.content.scan(/\d+$/)) }
    end

    def image_count
      results.inject { |sum, result| sum ? sum + result : result }
    end

    def ids
      @results.xpath('//result').map { |r| r.xpath('uri').first.content.scan(/\d+$/) }
    end

  end
end
