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

    stub_request(:any, "http://store.apple.com/apple-robots.txt").to_return(:status => 200, :body => File.read(@dir + 'fixtures/apple-robots.txt'))
    stub_request(:any, "http://store.apple.com/apple-index.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/apple-index.xml'))
    stub_request(:any, "http://store.apple.com/apple-sitemap.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/apple-sitemap.xml'))
    stub_request(:any, "http://store.apple.com/apple-sitemap-new.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/apple-sitemap-new.xml'))
  end

  it "Sitemap gracefully handles 404s" do
    SitemapChecker::Sitemap.new('http://www.github.com/404').errors.size.should eq(4)
  end

  it "Sitemap accepts xml siteindexes" do
    SitemapChecker::Sitemap.new('http://www.github.com/siteindex.xml').locs.size.should eq(4)
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

  it "Sitemap locs are Path objects" do
    SitemapChecker::Sitemap.new('http://www.github.com/sitemap.xml').locs.first.class.should eq(SitemapChecker::Path)
  end

  it "Path#status returns status code" do
    SitemapChecker::Path.new('http://www.github.com').status.should eq('200')
    SitemapChecker::Path.new('http://www.github.com/404').status.should eq('404')
  end

end
