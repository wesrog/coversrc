require 'zlib'

class Discogs
  def self.search(artist, track)
    at = URI.encode([artist, track].join(' '))
    uri = "http://www.discogs.com/search?type=all&q=#{at}&f=xml&api_key=#{DISCOGS_API_KEY}"
    req = open(uri, 'Accept-Encoding' => 'gzip')
    gzip = Zlib::GzipReader.new(req)
    doc = Nokogiri::XML(gzip)
    id = doc.xpath('//result/uri').first.content.scan(/\d+$/)
    uri = "http://www.discogs.com/release/#{id}?f=xml&api_key=#{DISCOGS_API_KEY}"
    req = open(uri, 'Accept-Encoding' => 'gzip')
    gzip = Zlib::GzipReader.new(req)
    doc = Nokogiri::XML(gzip)
    doc.xpath('//image').map { |i| i['uri'] }
  end

end
