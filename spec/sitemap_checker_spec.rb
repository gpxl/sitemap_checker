require 'rubygems'
require 'webmock/rspec'
require './lib/sitemap_checker'
WebMock.disable_net_connect!(:allow_localhost => true)

describe SitemapChecker do
  before(:each) do
    @dir  = Pathname.new(File.dirname(__FILE__))
    stub_request(:any, "http://www.github.com").to_return(:status => 200, :body => 'foo')
    stub_request(:any, "http://www.github.com/404").to_return(:status => 404, :body => 'foo')
    stub_request(:any, "http://www.github.com/index.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/valid_sitemap.xml'))
    stub_request(:any, "http://www.github.com/index.xml.gz").to_return(:status => 200, :body => File.read(@dir + 'fixtures/valid_sitemap.xml.gz'))
    stub_request(:get, "http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => File.read(@dir + 'fixtures/sitemap_schema.xml'), :headers => {})
  end

  it "accepts xml and gzipped files" do
    @xml_sitemap = SitemapChecker::Checker.new('http://www.github.com/index.xml')
    @gz_sitemap = SitemapChecker::Checker.new('http://www.github.com/index.xml.gz')
    @xml_sitemap.status_list.size.should eq(2)
    @gz_sitemap.status_list.size.should eq(2)
  end

  it "Errors if input doc does not match sitemap schema" do
    lambda {SitemapChecker::Checker.new('http://www.github.com')}.should raise_error(RuntimeError, 'Invalid Schema')
  end

  it "returns list of urls with responses" do
    @valid_sitemap = SitemapChecker::Checker.new('http://www.github.com/index.xml')
    @valid_sitemap.status_list.should eq([['http://www.github.com','200'], ['http://www.github.com/404','404']])
  end

end
