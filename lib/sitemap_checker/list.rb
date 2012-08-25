module SitemapChecker
  class List
    attr_accessor :urls, :sitemap

    def initialize(sitemap)
      @sitemap = sitemap
    end
  end
end
