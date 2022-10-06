#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'Presidents')]]//following-sibling::ul[1]//li")
  end

  class Officeholder < OfficeholderNonTableBase
    def name_node
      noko.css('a').first
    end

    def raw_combo_date
      noko.text.split(',', 2).last.gsub(/Since (.*)/, '\1 -').tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
