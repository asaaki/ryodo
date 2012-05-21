# encoding: utf-8

module Ryodo

  class QueryError < StandardError; end
  class NoMatchesError < StandardError; end

  class Query

    def initialize query
      raise QueryError, "Invalid query input!" if query.nil? || !query.is_a?(String) || query.empty?
      @raw_query = query
      build_query
    end

    def query
      @query
    end

    def build_query
      @query = if @raw_query.to_s[0] == "."
        # FQDN in reversed order
        @raw_query[1..-1].split(".")
      else
        @raw_query.split(".").reverse
      end
    end

    def get_rule_set
      @rule_set = Ryodo::RuleSet.new(@query, Ryodo::SuffixList.list)
    end

    def apply_rule_set
      @matches = (@rule_set || get_rule_set).apply
    end

    def best_match
      @result = (@matches || apply_rule_set).first
    end

  end

end