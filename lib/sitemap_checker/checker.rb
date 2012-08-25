module SitemapChecker
  class Checker
    attr_reader :list

    def initialize(url,schema='')
      @list = List.new(url)
      process_xml
    end

    def self.get_status_from_xml(url)
      get_status(url.content)
    end

    def self.get_status(url)
      begin
        status = Path.new(url,open(url).status[0])
      rescue OpenURI::HTTPError => e
        status = Path.new(url,e.io.status[0])
      end
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
      xml = get_xml_from_url(@list.sitemap)
      if mxsd.valid?(xml)
        @list.urls = urls(xml)
      elsif ixsd.valid?(xml)
        maps = urls(xml)
        maps.each do |map|
          xml = get_xml_from_url(map)
          @list.urls = urls(xml)
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
