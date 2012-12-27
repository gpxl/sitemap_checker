module SitemapChecker
  class Sitemap
    attr_accessor :locs, :uri

    def initialize(uri)
      @uri = SitemapChecker::Uri.new(uri)
      @locs = get_locs(@uri)
    end

    private

    def get_locs(uri)
      case
      when uri.xml.nil?
        nil
      when uri.is_siteindex
        process_siteindex(uri.xml)
      else
        get_uris(uri.xml)
      end
    end

    def process_siteindex(xml)
      @urls = []
      get_uris(xml).each do |loc|
        uri = SitemapChecker::Uri.new(loc)
        locs = get_locs(uri)
        if !locs.nil?
          @urls += get_uris(uri.xml)
        end
      end
      return @urls
    end

    def get_uris(xml)
      xml.xpath("//xmlns:loc").map{|path| path.content }
    end

  end
end
