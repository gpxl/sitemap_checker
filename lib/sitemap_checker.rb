require "sitemap_checker/version"
require 'open-uri'
require 'nokogiri'
require 'zlib'

module SitemapChecker
  class Checker
    attr_reader :status_list

    def initialize(url,schema='http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd')
      @schema = schema
      @url = url
      @sitemap = get_xml_from_url
      sitemap_is_valid?
      @status_list = get_status_list
    end

    private

    def get_xml_from_url
      begin
        Nokogiri::XML(Zlib::GzipReader.new(open(@url)))
      rescue
        Nokogiri::XML(open(@url))
      end
    end

    def sitemap_is_valid?
      xsd = Nokogiri::XML::Schema(open(@schema))
      raise 'Invalid Schema' unless xsd.valid?(@sitemap)
      true
    end

    def urls
      @sitemap.xpath("//xmlns:loc")
    end

    def get_status_list
      statuses = []
      urls.each do |url|
        begin
          status = [url.content,open(url).status[0]]
        rescue OpenURI::HTTPError => e
          status = [url.content,e.io.status[0]]
        end
        statuses << status
      end
      statuses
    end
  end

end
