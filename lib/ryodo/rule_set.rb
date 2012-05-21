# encoding: utf-8

module Ryodo

  class RuleSet

    def initialize query, list = SuffixList.list
      @query = query
      @list = list
    end

    def find_rules
      # preselect list items for matching first element
      # this is to reduce rule matching overhead
      list_items = @list.select do |elem|
        elem[0] == @query[0]
      end

      @preselection = list_items

      @rules = list_items.map do |elem|
        Ryodo::Rule.new(elem)
      end
    end

    def preselection
      @preselection || "run find_rules first!"
    end

    def rules
      @rules || find_rules
    end

    def find_matches
      matches = @rules.map do |rule|
        rule.match @query
      end

      @matches = matches.reject do |match|
        match.is_a?(Ryodo::NoMatch)
      end
    end

    def matches
      @matches || find_matches
    end

    def apply
      find_rules
      find_matches
    end

  end

end