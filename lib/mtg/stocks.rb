require "mtg/stocks/constants"
require 'net/http'

module Mtg
  class Stocks
    MTGSTOCKS_URL = "www.mtgstocks.com"

    def card_info( id )
      return nil unless id and id > 0

      response = Net::HTTP.get_response( MTGSTOCKS_URL, "/cards/#{id}" )
      if response.code == '200'
        tcg_id, card_name = tgc_id_and_name( response.body )
        set_name_s = set_name( response.body )

        return {
          low_price: price( response.body, :lowprice ),
          average_price: price( response.body, :avgprice ),
          high_price: price( response.body, :highprice ),
          foil_price: price( response.body, :foilprice ),
          tcg_id: tcg_id,
          card_name: card_name,
          set_name: set_name_s
        }
      else
        return nil
      end
    end

    def self.instance
      @@instance ||= Stocks.new
      return @@instance
    end

    def self.method_missing( name, *args, &block )
      return instance.send( name, *args, &block )
    end

    private

    def tgc_id_and_name( source )
      return source.scan( /<h2><a target="_blank" href="http:\/\/store\.tcgplayer\.com\/product\.aspx\?partner=MTGSTCKS&amp;id=([\d]+)">(.*?)<\/a>&nbsp;.*?<\/h2>/ ).first
    end

    def set_name( source )
      return source.scan( /<a href="\/sets\/[\d]+">(.*?)<\/a><\/h5>/ ).first[0]
    end

    def price( source, type )
      rtnval = 0.0
      prices = source.scan( /Prices of last 10 records.*?#{type}['"]>\$?(.*?)<\/td>/m )
      rtnval = prices.first.first if prices && prices.first && prices.first.first != 'N/A'
      return rtnval.to_f
    end
  end
end
