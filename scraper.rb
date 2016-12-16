#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'pry'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

class String
  def tidy
    self.gsub(/[[:space:]]+/, ' ').strip
  end
end

def noko_for(url)
  Nokogiri::HTML(open(url).read)
end

def scrape_list(url)
  noko = noko_for(url)
  noko.xpath('//h2[span[@id="Members"]]/following-sibling::ul[1]/li').each do |li|
    data = { 
      name: li.at_css('a').text.tidy,
      honorific_prefix: "Cardinal",
      wikiname: li.at_xpath('.//a[not(@class="new")][1]/@title').text,
      party_id: "_ind",
      party: "n/a",
      term: 2016,
    }
    ScraperWiki.save_sqlite([:name, :term], data)
  end
end

scrape_list("https://en.wikipedia.org/wiki/Pontifical_Commission_for_Vatican_City_State")
