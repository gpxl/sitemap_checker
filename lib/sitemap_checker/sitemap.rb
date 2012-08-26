module SitemapChecker
  class Sitemap
    attr_accessor :locs, :map

    def initialize(map)
      @map = map
      @locs = process_map
    end

    private

    def process_map
      xml = get_xml_from_map(@map)
      if is_siteindex?(xml)
        process_siteindex(xml)
      else
        process_sitemap(xml)
      end
    end

    def get_xml_from_map(map)
      begin
        Nokogiri::XML(Zlib::GzipReader.new(open(map)))
      rescue
        Nokogiri::XML(open(map))
      end
    end

    def is_siteindex?(xml)
      ixsd = Nokogiri::XML::Schema(open('http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd'))
      ixsd.valid?(xml)
    end

    def is_sitemap?(xml)
      mxsd = Nokogiri::XML::Schema(open('http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'))
      mxsd.valid?(xml)
    end

    def process_siteindex(xml)
      @urls = []
      maps = get_locs(xml)
      maps.each do |map|
        xml = get_xml_from_map(map.url)
        @urls += process_sitemap(xml)
      end
      return @urls
    end

    def process_sitemap(xml)
      if is_sitemap?(xml)
        return get_locs(xml)
      else raise 'Invalid Schema'
        return false
      end
    end

    def get_locs(xml)
      xml.xpath("//xmlns:loc").map{|path| Path.new(path) }
    end

  end
end
