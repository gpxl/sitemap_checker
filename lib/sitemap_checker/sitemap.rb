require 'nokogiri'

module SitemapChecker
  class Sitemap
    attr_accessor :locs, :map

    def initialize(map)
      @map = Uri.new(map)
      if @map.io.status[0] == '200'
        @locs = process_map(@map)
      else
        @locs = nil
      end
    end

    private

    def process_map(map)
      xml = get_xml_from_map(@map)
      if is_siteindex?(xml)
        process_siteindex(xml)
      else
        process_sitemap(xml)
      end
    end

    def get_xml_from_map(map)
      case map.io.content_type
      when 'application/octet-stream'
        Nokogiri::XML(Zlib::GzipReader.new(map.io))
      when 'application/xml'
        Nokogiri::XML(map.io)
      else
        nil
      end
    end

    def is_siteindex?(xml)
      xml.xpath('//xmlns:sitemap').size > 0
    end

    def process_siteindex(xml)
      @urls = []
      maps = get_locs(xml)
      maps.each do |map|
        xml = get_xml_from_map(Uri.new(map))
        @urls += process_sitemap(xml)
      end
      return @urls
    end

    def process_sitemap(xml)
      return get_locs(xml)
    end

    def get_locs(xml)
      xml.xpath("//xmlns:loc").map{|path| path.content }
    end

  end
end
