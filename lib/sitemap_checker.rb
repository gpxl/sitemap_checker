require "sitemap_checker/version"
require 'open-uri'
require 'nokogiri'
require 'zlib'


module SitemapChecker
  autoload :Path, "sitemap_checker/path"
  autoload :List, "sitemap_checker/list"
  autoload :Checker, "sitemap_checker/checker"
end
