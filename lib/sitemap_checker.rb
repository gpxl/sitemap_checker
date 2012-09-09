require 'open-uri'
require 'nokogiri'
require 'zlib'

require "sitemap_checker/version"
require "sitemap_checker/open_uri"

module SitemapChecker
  autoload :Sitemap, "sitemap_checker/sitemap"
  autoload :Path, "sitemap_checker/path"
end
