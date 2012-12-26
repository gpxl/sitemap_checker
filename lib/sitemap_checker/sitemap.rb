module SitemapChecker
  class Sitemap
    attr_accessor :locs, :uri

    def initialize(uri)
      @uri = Uri.new(uri)
      @locs = process_uri(@uri)
    end

    private

    def process_uri(uri)
      uri.xml.nil? ? nil : process_xml(uri.xml)
    end

    def process_xml(xml)
      is_siteindex?(xml) ? process_siteindex(xml) : get_locs(xml)
    end

    def process_siteindex(xml)
      @urls = []
      get_locs(xml).each do |loc|
        uri = Uri.new(loc)
        locs = process_uri(uri)
        if !locs.nil?
          @urls += get_locs(uri.xml)
        end
      end
      return @urls
    end

    def is_siteindex?(xml)
      xml.xpath('//xmlns:sitemap').size > 0
    end

    def get_locs(xml)
      xml.xpath("//xmlns:loc").map{|path| path.content }
    end

  end
end
