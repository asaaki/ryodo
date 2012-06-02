# encoding: utf-8

module Ryodo
  class Domain

    # remove class comparison
    undef_method :==

    def initialize domainStr
      @domain_string = domainStr.downcase

      parts = Ryodo::Parser.run(@domain_string)

      @suffix    = parts ? parts[0].reverse.join(".") : nil
      @domain    = parts && !parts[1].empty? ? (parts[0] + parts[1]).reverse.join(".") : nil
      @subdomain = parts && !parts[2].empty? ? (parts[2]).reverse.join(".") : nil
    end

    def suffix
      @suffix
    end
    alias_method :tld, :suffix

    def domain
      @domain
    end
    alias_method :registered_domain, :domain

    def subdomain
      @subdomain
    end

    def to_s
      @domain_string.to_s
    end

    def inspect
      @domain_string.inspect
    end

    # pass all missings to @domain_string (String class)
    def method_missing(name, *args, &block)
      @domain_string.send(name, *args, &block)
    end

    # explicit definition of class' send
    def send(symbol, *args)
      __send__(symbol, *args)
    end

  end
end