# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sitemap_checker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gerlando Piro"]
  gem.email         = ["gerlando@gmail.com"]
  gem.description   = %q{SiteMap Checker}
  gem.summary       = %q{Gets status of Urls in SiteMap}
  gem.homepage      = "https://github.com/gerlandop/sitemap_checker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sitemap_checker"
  gem.require_paths = ["lib"]
  gem.version       = SitemapChecker::VERSION

  gem.add_dependency 'nokogiri'
end
