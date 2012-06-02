# encoding: utf-8

module Ryodo
  class Parser

    def initialize
      @rules = Ryodo::RuleSet.new
    end

    def build_query domain
      if domain.to_s[0] == "."
        # FQDN in reversed order
        domain.downcase[1..-1].split(".")
      else
        domain.downcase.split(".").reverse
      end
    end

    def parse domain
      @rules.match build_query(domain)
    end

    class << self

      def run domain
        instance.parse domain
      end


      def instance
        @@instance ||= new
      end

    end

  end
end