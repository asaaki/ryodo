# encoding: utf-8

module Ryodo

  class RuleSet

    def initialize query, list = SuffixList.list
      @query = query
      @list  = list
    end

    def find_rules
      # preselect list items for matching first element
      # this is to reduce possible rule matching overhead
      # especially on very short queries
      list_items = @list.select do |elem|
        elem.first == @query.first
      end

      @rules = list_items.map do |elem|
        Ryodo::Rule.new(elem)
      end
    end

    def rules
      @rules ||= find_rules
    end

    def find_matches
      all_matches   = self.rules.map{ |rule| rule.match @query }

      valid_matches = all_matches.select{ |match| match.valid? }

      real_matches  = valid_matches.select{ |match| match.match? }
      exception     = valid_matches.select{ |match| match.exception? }
      wildcard      = valid_matches.select{ |match| match.wildcard? }
      exact_suffix  = valid_matches.select{ |match| match.exact_suffix? }

      match_set = {}
      match_set[:matches]    = real_matches
      match_set[:exception]  = exception.first # should always be a single element
      match_set[:wildcard]   = wildcard.first # should always be a single element
      match_set[:exact_suffix] = exact_suffix

      match_set
    end

    def matches
      @matches ||= find_matches
    end

    def find_best_match
      eventual_best = matches[:matches].sort.last

      if    matches[:exception] && !matches[:exception].match? && eventual_best != matches[:exception]
        nil
      elsif matches[:exception] == eventual_best
        eventual_best
      elsif matches[:wildcard]  && !matches[:wildcard].match?  && eventual_best != matches[:wildcard]
        nil
      elsif !matches[:exact_suffix].empty? #&& eventual_best == matches[:exact_suffix]
        nil
      else
        eventual_best
      end
    end

  end

end