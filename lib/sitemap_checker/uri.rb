require 'open-uri'

module SitemapChecker
  class Uri
    attr_accessor :uri, :io

    def initialize(uri)
      @uri = uri
      @io = open_io
    end

    def open_io
      begin
        open(@uri)
      rescue RuntimeError => e
        e
      rescue OpenURI::HTTPError => e
        e.io
      end
    end
  end
end
