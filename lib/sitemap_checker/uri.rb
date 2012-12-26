require 'open-uri'
require 'nokogiri'

module SitemapChecker
  class Uri
    attr_accessor :uri, :xml

    def initialize(uri)
      @uri = uri
      @xml = extract_xml
    end

    def extract_xml
      if io = open_io
        case io.content_type
        when 'application/xml'
          Nokogiri::XML(io)
        when 'application/octet-stream'
          Nokogiri::XML(Zlib::GzipReader.new(io))
        else
          nil
        end
      end
    end

    def open_io
      begin
        open(@uri)
      rescue OpenURI::HTTPError => e
        nil
      end
    end
  end
end
