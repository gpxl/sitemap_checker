require "sitemap_checker/version"
require 'open-uri'
require 'nokogiri'
require 'zlib'


module SitemapChecker
  autoload :Sitemap, "sitemap_checker/sitemap"
  autoload :Path, "sitemap_checker/path"
end
