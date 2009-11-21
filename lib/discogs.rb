require 'zlib'

module Gzipper
  def gzip_read(data)
    Zlib::GzipReader.new(data)
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

    def initialize(now_playing)
      @uri = "http://www.discogs.com/search?type=all&q=#{URI.encode(now_playing)}&f=xml&api_key=#{DISCOGS_API_KEY}"
      @req = open(@uri, 'Accept-Encoding' => 'gzip', 'User-Agent' => 'coversrc/1.0 +http://coversrc.com')
    end

    def response
      @req
    end

    def read
      @results = gzip_read(@req)
    end

    def doc
      Nokogiri::XML(read)
    end

    def uri
      @uri
    end

    def results
      doc.xpath('//result').map { |r| Discogs::Release.new(r.xpath('uri').first.content.scan(/\d+$/)) }
    end

    def image_count
      results.inject { |sum, result| sum ? sum + result : result }
    end

    def ids
      @results.xpath('//result').map { |r| r.xpath('uri').first.content.scan(/\d+$/) }
    end

  end
end
