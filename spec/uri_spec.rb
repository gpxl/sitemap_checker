require 'rubygems'
require 'webmock/rspec'
require './lib/sitemap_checker/uri'
WebMock.disable_net_connect!(:allow_localhost => true)

describe 'SitemapChecker::Uri' do

  before(:each) do
    stub_request(:any, "http://www.io.com/index.xml").to_return(:status => 200, :body => 'foo')
    stub_request(:any, "http://www.io.com").to_return(:status => 200, :body => 'foo')
    stub_request(:any, "http://www.io.com/404").to_return(:status => 404, :body => 'foo')
  end

  it "contains an IO object" do
    SitemapChecker::Uri.new('http://www.io.com').io.class.name.should eq('StringIO')
  end

  it "handles 404's" do
    SitemapChecker::Uri.new('http://www.io.com/404').io.class.name.should eq('StringIO')
  end

end
