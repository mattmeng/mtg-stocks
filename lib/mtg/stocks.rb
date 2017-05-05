require "mtg/stocks/constants"
require 'net/http'

module Mtg
  class Stocks
    MTGSTOCKS_URL = "www.mtgstocks.com"

    def card_info( id )
      return nil unless id and id > 0

      html = Net::HTTP.get( MTGSTOCKS_URL, "/cards/#{id}" )
      return nil unless html

      tcg_id, card_name = tgc_id_and_name( html )
      set_name_s = set_name( html )

      return {
        low_price: price( html, :lowprice ),
        average_price: price( html, :avgprice ),
        high_price: price( html, :highprice ),
        foil_price: price( html, :foilprice ),
        tcg_id: tcg_id,
        card_name: card_name,
        set_name: set_name_s
      }
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
      rtnval = source.scan( /Prices of last 10 records.*?#{type}['"]>\$?(.*?)<\/td>/m )
      rtnval = rtnval.first.first
      rtnval = 0.0 if rtnval == 'N/A'
      return rtnval.to_f
    end
  end
end
