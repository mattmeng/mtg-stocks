require "mtg/stocks/constants"
require 'net/http'

module Mtg
  class Stocks
    MTGSTOCKS_URL = "www.mtgstocks.com"

    def card_price( id )
      return nil unless id and id > 0

      html = Net::HTTP.get( MTGSTOCKS_URL, "/cards/#{id}" )
      return nil unless html

      return [
        price( html, :lowprice ),
        price( html, :avgprice ),
        price( html, :highprice ),
        price( html, :foilprice )
      ]
    end

    def self.instance
      @@instance ||= Stocks.new
      return @@instance
    end

    def self.method_missing( name, *args, &block )
      return instance.send( name, *args, &block )
    end

    private

    def price( source, type )
      rtnval = source.scan( /Prices of last 10 records.*?#{type}['"]>\$?(.*?)<\/td>/m )
      rtnval = rtnval.first.first
      rtnval = 0.0 if rtnval == 'N/A'
      return rtnval.to_f
    end
  end
end
