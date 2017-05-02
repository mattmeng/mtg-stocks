require "mtg/stocks/constants"

module Mtg
  class Stocks
    MTGSTOCKS_URL = "http://www.mtgstocks.com/cards/"

    def card_price( id )
      return nil unless id and id > 0

      html = open( MTGSTOCKS_URL + id.to_s )
      return nil unless html

      /lowprice['"]>\$?(.*?)<\/td>/
    end

    def self.instance
      return @@instance || Stocks.new
    end

    def self.method_missing( name, *args, &block )
      return instance.send( name, *args, &block )
    end
  end
end
