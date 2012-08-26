# SitemapChecker

Takes a url pointing to an xml or xml.gz sitemap or siteindex file and returns array of urls contained within.

## Installation

Add this line to your application's Gemfile:

    gem 'sitemap_checker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sitemap_checker

## Usage

Get list of urls(locs) from xml or xml.gz sitemap url.
    
    @sitemap = SitemapChecker::Sitemap.new(url)
    @sitemap.locs.size

Get status of url from Sitemap

    @sitemap = SitemapChecker::Sitemap.new(url)
    @sitemap.locs.first.status

or directly as a Path

    SitemapChecker::Path.new(url).status

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

