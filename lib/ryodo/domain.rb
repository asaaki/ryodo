# encoding: utf-8

module Ryodo
  class Domain

    # DomainString is a String with extended methods
    class DomainString < String

      def reverse
        to_a(:r).join(".")
      end
      alias_method :r, :reverse

      def to_a option = nil
        case option
        when :reverse, :r
          dsplit.reverse
        else
          dsplit
        end
      end

    private

      def dsplit
        self.split(".",-1)
      end

    end

    # remove own class comparison (we will use String#== via method_missing)
    undef_method :==

    def initialize domainStr
      raise TypeError, "Not a valid domain string!" unless domainStr.is_a?(String)
      @domain_string = DomainString.new domainStr.downcase
      no_leading_dot = @domain_string[0] != "."

      parts = Ryodo::Parser.run(@domain_string)

      @suffix    = no_leading_dot && parts                     ?  parts[0].reverse.join(".")             : nil
      @domain    = no_leading_dot && parts && !parts[1].empty? ? (parts[0] + parts[1]).reverse.join(".") : nil
      @secondary = no_leading_dot && parts && !parts[1].empty? ?  parts[1].first                         : nil
      @subdomain = no_leading_dot && parts && !parts[2].empty? ? (parts[2]).reverse.join(".")            : nil
    end

    def suffix
      DomainString.new @suffix if @suffix
    end
    alias_method :tld, :suffix

    def domain
      DomainString.new @domain if @domain
    end
    alias_method :registered_domain, :domain
    alias_method :regdomain,         :domain

    def second_level
      DomainString.new @secondary if @secondary
    end
    alias_method :sld,             :second_level
    alias_method :registered_name, :second_level

    def subdomain
      DomainString.new @subdomain if @subdomain
    end

    def fqdn
      DomainString.new "#{to_s}."
    end

    def is_valid?
      !!@suffix && !!@secondary
    end
    alias_method :valid?, :is_valid?

    def to_s
      @domain_string
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
