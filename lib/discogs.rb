require 'zlib'

class NoResultsFound < StandardError; end

API_BASE = 'http://www.discogs.com/search'

class Discogs
  attr_reader :doc, :uri, :response

  def initialize(uri)
    @uri = uri
    @response = open(@uri, 'Accept-Encoding' => 'gzip', 'User-Agent' => 'coversrc/1.0 +http://coversrc.com')
    data = Zlib::GzipReader.new(@response)
    @doc = Nokogiri::XML(data)
  rescue Zlib::GzipFile::Error
    @response.seek(0)
    @doc = Nokogiri::XML(@response.read)
  end
end

class Search < Discogs
  def initialize(now_playing)
    super("#{API_BASE}?type=all&q=#{URI.encode(now_playing)}&f=xml&api_key=#{DISCOGS_API_KEY}")
  end

  def results
    nodes = @doc.xpath('//result')
    if nodes.empty?
      raise NoResultsFound
    else
      nodes
    end
  end

  def releases
    results.map do |r|
      Release.new(r.xpath('uri').first.content.scan(/\d+$/))
    end
  end
end

class Release < Discogs
  attr_reader :discogs_id

  def initialize(id)
    @discogs_id = id
    super("http://www.discogs.com/release/#{@discogs_id}?f=xml&api_key=#{DISCOGS_API_KEY}")
  end

  def title
    @doc.xpath('//title').first.content
  end

  def image
    if uri = @doc.xpath('//image').first
      uri['uri']
    end
  end

  def format
    @doc.xpath('//format').first['name']
  end

  def image_count
    @doc.xpath('//image').size
  end

  def genres
    @doc.xpath('//genre')
  end

  def styles
    @doc.xpath('//style')
  end
end
