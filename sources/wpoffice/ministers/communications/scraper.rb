#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  def holder_entries
    noko.xpath("//h2[.//span[contains(.,'Informática y las Comunicaciones')]][1]//following-sibling::ul[1]//li")
  end

  class Officeholder < OfficeholderNonTableBase
    def item
      name_link.attr('wikidata') if name_link
    end

    def itemLabel
      name_link ? name_link.text.tidy : noko.text.split(/\d/).last.tidy
    end

    def raw_combo_date
      noko.text.gsub(itemLabel, '').gsub(/^ab /, 'seit ').gsub(/seit (.*?) /, '\1 - ').tidy
    end

    private

    def name_link
      noko.at_css('a')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
