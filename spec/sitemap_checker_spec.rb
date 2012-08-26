require 'rubygems'
require 'webmock/rspec'
require './lib/sitemap_checker'
WebMock.disable_net_connect!(:allow_localhost => true)

describe SitemapChecker do
  before(:each) do
    @dir  = Pathname.new(File.dirname(__FILE__))
    stub_request(:any, "http://www.github.com").to_return(:status => 200, :body => 'foo')
    stub_request(:any, "http://www.github.com/404").to_return(:status => 404, :body => 'foo')
    stub_request(:any, "http://www.github.com/sitemap.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/sitemap.xml'))
    stub_request(:any, "http://www.github.com/sitemap.xml.gz").to_return(:status => 200, :body => File.read(@dir + 'fixtures/sitemap.xml.gz'))
    stub_request(:any, "http://www.github.com/siteindex.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/siteindex.xml'))
    stub_request(:any, "http://www.github.com/siteindex.xml.gz").to_return(:status => 200, :body => File.read(@dir + 'fixtures/siteindex.xml.gz'))
    stub_request(:get, "http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd").to_return(:status => 200, :body => File.read(@dir + 'fixtures/sitemap.xsd'), :headers => {})
    stub_request(:get, "http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd").to_return(:status => 200, :body => File.read(@dir + 'fixtures/siteindex.xsd'), :headers => {})
  end

  it "Sitemap accepts xml siteindexes" do
    @list = SitemapChecker::Sitemap.new('http://www.github.com/siteindex.xml')
    @list.locs.size.should eq(4)
  end

  it "Sitemap accepts gzipped siteindexes" do
    @list = SitemapChecker::Sitemap.new('http://www.github.com/siteindex.xml.gz')
    @list.locs.size.should eq(4)
  end

  it "Sitemap accepts xml sitemaps" do
    @list = SitemapChecker::Sitemap.new('http://www.github.com/sitemap.xml')
    @list.locs.size.should eq(2)
  end

  it "Sitemap accepts xml and gzipped sitemaps" do
    @xml_sitemap = SitemapChecker::Sitemap.new('http://www.github.com/sitemap.xml')
    @gz_sitemap = SitemapChecker::Sitemap.new('http://www.github.com/sitemap.xml.gz')
    @xml_sitemap.locs.size.should eq(2)
    @gz_sitemap.locs.size.should eq(2)
  end

  it "Sitemap errors if input doc does not match sitemap schema" do
    lambda {SitemapChecker::Sitemap.new('http://www.github.com')}.should raise_error(RuntimeError, 'Invalid Schema')
  end

  it "Sitemap locs are Path objects" do
    @xml_sitemap = SitemapChecker::Sitemap.new('http://www.github.com/sitemap.xml')
    @xml_sitemap.locs.first.class.should eq(SitemapChecker::Path)
  end

  it "Path#status returns status code" do
    SitemapChecker::Path.new('http://www.github.com').status.should eq('200')
  end

end
