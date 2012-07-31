require "sitemap_checker/version"
require 'open-uri'
require 'nokogiri'
require 'zlib'

module SitemapChecker
  class Checker
    attr_reader :status_list

    def initialize(url,schema='')
      @url = url
      @status_list = Array.new
      process_xml
    end

    private

    def get_xml_from_url(url)
      begin
        Nokogiri::XML(Zlib::GzipReader.new(open(url)))
      rescue
        Nokogiri::XML(open(url))
      end
    end

    def process_xml
      mxsd = Nokogiri::XML::Schema(open('http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'))
      ixsd = Nokogiri::XML::Schema(open('http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd'))
      xml = get_xml_from_url(@url)
      if mxsd.valid?(xml)
        @status_list = get_status_list(urls(xml))
      elsif ixsd.valid?(xml)
        maps = urls(xml)
        maps.each do |map|
          xml = get_xml_from_url(map)
          @status_list += get_status_list(urls(xml))
        end
      else raise 'Invalid Schema'
        false
      end
    end

    def urls(xml)
      xml.xpath("//xmlns:loc")
    end

    def get_status_list(urls)
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
