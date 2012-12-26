require 'rubygems'
require 'webmock/rspec'
require './lib/sitemap_checker/sitemap'
require './lib/sitemap_checker/uri'
WebMock.disable_net_connect!(:allow_localhost => true)

describe 'SitemapChecker::Sitemap' do
  before(:each) do
    @dir  = Pathname.new(File.dirname(__FILE__))
    stub_request(:any, "http://www.github.com").to_return(:status => 200, :body => 'foo', headers: {'Content-type' => 'text/html'})
    stub_request(:any, "http://www.github.com/404").to_return(:status => 404, :body => 'foo', headers: {'Content-type' => 'text/html'})
    stub_request(:any, "http://www.github.com/sitemap.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/sitemap.xml'), headers: {'Content-type' => 'application/xml'})
    stub_request(:any, "http://www.github.com/sitemap.xml.gz").to_return(:status => 200, :body => File.read(@dir + 'fixtures/sitemap.xml.gz'), headers: {'Content-type' => 'application/octet-stream'})
    stub_request(:any, "http://www.github.com/siteindex.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/siteindex.xml'), headers: {'Content-type' => 'application/xml'})
    stub_request(:any, "http://www.github.com/siteindex.xml.gz").to_return(:status => 200, :body => File.read(@dir + 'fixtures/siteindex.xml.gz'), headers: {'Content-type' => 'application/octet-stream'})
    stub_request(:any, "http://store.apple.com/apple-robots.txt").to_return(:status => 200, :body => File.read(@dir + 'fixtures/apple-robots.txt'), headers: {'Content-type' => 'text/plain'})
    stub_request(:any, "http://store.apple.com/apple-index.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/apple-index.xml'), headers: {'Content-type' => 'application/xml'})
    stub_request(:any, "http://store.apple.com/apple-sitemap.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/apple-sitemap.xml'), headers: {'Content-type' => 'application/xml'})
    stub_request(:any, "http://store.apple.com/apple-sitemap-new.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/apple-sitemap-new.xml'), headers: {'Content-type' => 'application/xml'})
  end

  it "Sitemap gracefully handles 404s" do
    lambda { SitemapChecker::Sitemap.new('http://www.github.com/404') }.should_not raise_error
  end

  it "Sitemap accepts xml siteindexes" do
    SitemapChecker::Sitemap.new('http://www.github.com/siteindex.xml').locs.size.should eq(4)
    SitemapChecker::Sitemap.new('http://store.apple.com/apple-index.xml').locs.size.should eq(419)
    SitemapChecker::Sitemap.new('http://store.apple.com/apple-sitemap.xml').locs.size.should eq(214)
    SitemapChecker::Sitemap.new('http://store.apple.com/apple-sitemap-new.xml').locs.size.should eq(205)
  end

  it "Sitemap accepts gzipped siteindexes" do
    SitemapChecker::Sitemap.new('http://www.github.com/siteindex.xml.gz').locs.size.should eq(4)
  end

  it "Sitemap accepts xml sitemaps" do
    SitemapChecker::Sitemap.new('http://www.github.com/sitemap.xml').locs.size.should eq(2)
  end

  it "Sitemap accepts gzipped sitemaps" do
    SitemapChecker::Sitemap.new('http://www.github.com/sitemap.xml.gz').locs.size.should eq(2)
  end

  it "Sitemap locs are String objects" do
    SitemapChecker::Sitemap.new('http://www.github.com/sitemap.xml').locs.first.class.should eq(String)
  end

end
