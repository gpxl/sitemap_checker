require 'rubygems'
require 'webmock/rspec'
require './lib/sitemap_checker/uri'
WebMock.disable_net_connect!(:allow_localhost => true)

describe 'SitemapChecker::Uri' do

  before(:each) do
    @dir  = Pathname.new(File.dirname(__FILE__))
    stub_request(:any, "http://www.github.com/404").to_return(:status => 404)
    stub_request(:any, "http://www.github.com/sitemap.xml").to_return(:status => 200, :body => File.read(@dir + 'fixtures/sitemap.xml'), headers: {'Content-type' => 'application/xml'})
    stub_request(:any, "http://www.github.com/sitemap.xml.gz").to_return(:status => 200, :body => File.read(@dir + 'fixtures/sitemap.xml.gz'), headers: {'Content-type' => 'application/octet-stream'})
  end

  it "Accepts XML" do
    SitemapChecker::Uri.new('http://www.github.com/sitemap.xml').xml.class.should eq(Nokogiri::XML::Document)
  end

  it "Accepts Gzipped XML" do
    SitemapChecker::Uri.new('http://www.github.com/sitemap.xml.gz').xml.class.should eq(Nokogiri::XML::Document)
  end

  it "does not contain IO object if not xml or gz" do
    SitemapChecker::Uri.new('http://www.github.com/404').xml.class.should eq(NilClass)
  end

end
