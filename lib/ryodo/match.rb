# encoding: utf-8

module Ryodo

  class Match

    def initialize rule, query
      @rule   = rule
      @query  = query

      @domain = domain_match
      @cookie = cookie_domain_match

      @result = get_result
    end

    def domain_match
      range =
        if r_end = @rule.index(:rest)
          0..r_end
        else
          0..-2
        end
      @rule[range]
    end

    def cookie_domain_match
      range =
        if    r_end = @rule.index(:override)
          0..r_end

        elsif r_end = @rule.index(:wildcard)
          0..(r_end+1)

        else
          0..@rule.index(:rest)
        end

      @rule[range]
    end

    def get_priority
      @domain.select do |elem|
        [true, :wildcard, :override].include?(elem)
      end.length
    end

    def get_result
      {
        :prio      => get_priority,
        :domain    => @query[0..(@domain.length-1)],
        :subdomain => @query[(@domain.length)..-1],
        :cookie    => @query[0..(@cookie.length-1)]
      }
    end

    def result
      @result
    end

  end

end