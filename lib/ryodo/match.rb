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
        if r_end = @rule.index(:rest) || @rule.index(:override) || @rule.index(:wildcard) || @rule.index(true) || 0
          0..r_end
        else
          0..-2
        end

      @rule[range].map do |elem|
        if [:wildcard,:override].include?(elem)
          true
        else
          elem
        end
      end
    end

    def cookie_domain_match
      range =
        if    r_end = @rule.index(:override)
          0..r_end

        elsif r_end = @rule.index(:wildcard)
          0..(r_end+1)

        else
          0..(@rule.index(:rest) || 0)
        end

      @rule[range]
    end

    def get_priority
      @domain.select do |elem|
        [true, :wildcard, :override].include?(elem)
      end.length
    end

    def matched?
      !@rule.include?(false) && (@rule.include?(:rest) || @rule.last == :override)
    end
    alias_method :matches?, :matched?
    alias_method :match?, :matched?

    def get_domain
      @query[0..(@domain.length-1)]
    end

    def get_subdomain
      @query[(@domain.length)..-1]
    end

    def get_cookie
      @query[0..(@cookie.length-1)]
    end

    def get_result
      {
        :prio      => get_priority,
        :matched   => matched?,
        :domain    => get_domain,
        :domain_m  => @domain,
        :subdomain => get_subdomain,
        :cookie    => get_cookie,
        :cookie_m  => @cookie
      }
    end

    def result
      @result
    end

    # deep comparison of matched results
    # reversed order => highest match first!
    # first level: prio
    # second level: domain parts
    # third level: cookie parts
    # finally on cookie level no zero should appear
    def <=> other
      r0, r1 = self.result, other.result
      prio = r1[:prio] <=> r0[:prio]
      if prio == 0
        dom = match_to_int(r1[:domain_m]) <=> match_to_int(r0[:domain_m])
        if dom == 0
          match_to_int(r1[:cookie_m]) <=> match_to_int(r0[:cookie_m])
        else
          dom
        end
      else
        prio
      end
    end

  private

    def apply_rule rule, item, as = :domain
      res = []
      item.each_with_index do |elem, index|
        if as == :cookie
          next if [false,:rest].include?(rule[index])
          res << elem
        else
          next if [false,:rest].include?(rule[index])
          res << elem
        end
      end
    end

    def match_to_int match
      match.map do |e|
        case e
        when true
          3
        when :override
          2
        when :wildcard
          1
        else
          0
        end
      end
    end

  end

end