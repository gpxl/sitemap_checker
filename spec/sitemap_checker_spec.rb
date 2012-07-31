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

  it "accepts xml and gzipped siteindexes" do
    @xml_sitemap = SitemapChecker::Checker.new('http://www.github.com/siteindex.xml')
    @gz_sitemap = SitemapChecker::Checker.new('http://www.github.com/siteindex.xml.gz')
    @xml_sitemap.status_list.size.should eq(4)
    @gz_sitemap.status_list.size.should eq(4)
  end

  it "accepts xml and gzipped sitemaps" do
    @xml_sitemap = SitemapChecker::Checker.new('http://www.github.com/sitemap.xml')
    @gz_sitemap = SitemapChecker::Checker.new('http://www.github.com/sitemap.xml.gz')
    @xml_sitemap.status_list.size.should eq(2)
    @gz_sitemap.status_list.size.should eq(2)
  end

  it "Errors if input doc does not match sitemap schema" do
    lambda {SitemapChecker::Checker.new('http://www.github.com')}.should raise_error(RuntimeError, 'Invalid Schema')
  end

  it "returns list of urls with responses from sitemap" do
    @sitemap = SitemapChecker::Checker.new('http://www.github.com/sitemap.xml')
    @sitemap.status_list.should eq([['http://www.github.com','200'], ['http://www.github.com/404','404']])
  end

  it "returns list of urls with responses from siteindex" do
    @siteindex = SitemapChecker::Checker.new('http://www.github.com/siteindex.xml')
    @siteindex.status_list.should eq([['http://www.github.com','200'], ['http://www.github.com/404','404'], ['http://www.github.com','200'], ['http://www.github.com/404','404']])
  end

end
