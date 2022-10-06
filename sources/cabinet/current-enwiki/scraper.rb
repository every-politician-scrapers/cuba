#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      # Multiple members in some rows, so find the people first, and work back
      noko.xpath("//table[.//th[contains(.,'Incumbent')]]//tr[td]//td[2]//a")
    end
  end

  class Member
    field :id do
      noko.attr('wikidata')
    end

    field :name do
      noko.text.tidy
    end

    field :positionID do
    end

    field :position do
      position_cell.css('a').any? ? position_cell.css('a').map(&:text).map(&:tidy).first : position_cell.text.split('(').first.tidy
    end

    field :startDate do
    end

    field :endDate do
    end

    private

    def position_cell
      noko.xpath('ancestor::tr//td[1]')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
