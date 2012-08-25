module SitemapChecker
  class Path
    attr_accessor :url, :status

    def initialize(url,status)
      @url = url
      @status = status
    end
  end
end
