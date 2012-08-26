require "sitemap_checker/version"
require 'open-uri'
require 'nokogiri'
require 'zlib'


module SitemapChecker
  autoload :Sitemap, "./lib/sitemap_checker/sitemap"
  autoload :Path, "./lib/sitemap_checker/path"
end
