# encoding: utf-8

module Ryodo

  class NoMatch < Ryodo::Match

    def domain_match
      last_part = @rule[-1]
      if last_part == :wildcard || last_part == :override
        :tld
      else
        :invalid
      end
    end

    def cookie_domain_match
      false
    end

    def get_result
      @domain
    end

  end

end