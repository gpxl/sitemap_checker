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
        Nokogiri::XML(Zlib::GzipReader.new(open(map, {:allow_unsafe_redirects => true})))
      rescue
        Nokogiri::XML(open(map, {:allow_unsafe_redirects => true}))
      end
    end

    def is_siteindex?(xml)
      xml.xpath('//xmlns:sitemap').size > 0
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
      return get_locs(xml)
    end

    def get_locs(xml)
      xml.xpath("//xmlns:loc").map{|path| Path.new(path.content) }
    end

  end
end
