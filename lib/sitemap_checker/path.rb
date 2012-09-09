module SitemapChecker
  class Path
    attr_accessor :url, :status

    def initialize(url)
      @url = url
      @status = nil
    end

    def get_status_from_xml(url)
      status(url.content)
    end

    def status
      begin
        @status ||= open(@url).status[0]
      rescue OpenURI::HTTPError => e
        e.io.status[0]
      end
    end
  end
end