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
        elem.first == @query.first
      end

      @rules = list_items.map do |elem|
        Ryodo::Rule.new(elem)
      end
    end

    def rules
      @rules || find_rules
    end

    def find_matches
      matches = @rules.map do |rule|
        rule.match @query
      end.sort{|a,b| a <=> b }

      would_match = matches.first # possible best match, also if it fails

      matches = matches.select do |match|
        match.matched?
      end

      if matches.include?(would_match)
        @matches = matches
      else
        []
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