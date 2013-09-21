# encoding: utf-8

module Ryodo
  class Parser

    def initialize
      @rules = Ryodo::RuleSet.new
    end

    def build_query domain
      domain.split(".").reverse
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
