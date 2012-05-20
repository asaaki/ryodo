# encoding: utf-8

module Ryodo

  class RuleSet

    def initialize query, list = SuffixList.list
      @query = query
      @list = list
    end

    def find_rules
      list_items = @list.select do |elem|
        elem[0] == @query
      end
      @rules = list_items.map do |elem|
        Ryodo::Rule.new(elem)
      end
      @rules
    end

    def apply!
      find_rules
      @rules
    end

  end

end