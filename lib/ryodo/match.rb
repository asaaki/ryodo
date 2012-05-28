# encoding: utf-8

module Ryodo

  class Match

    def initialize suffix, query, rule
      @suffix = suffix
      @query  = query
      @rule   = rule

      @is_valid = is_valid?
      @is_match = is_match?

      @domain    = get_domain
      @cookie    = get_cookie
      @subdomain = get_subdomain

      self.values
    end

    def is_valid?
      @rule.none?{|label| label == false }
    end
    alias_method :valid?, :is_valid?
    alias_method :suffix?, :is_valid?

    def is_exception?
      @rule.include?(:override)
    end
    alias_method :exception?, :is_exception?

    def is_wildcard?
      @rule.include?(:wildcard) || @rule.include?(:wildcard_false)
    end
    alias_method :wildcard?, :is_wildcard?

    def is_exact_suffix?
      @suffix.length == @query.length
    end
    alias_method :exact_suffix?, :is_exact_suffix?

    def is_match?
      is_valid? && (
          (@query.length > @suffix.length) ||
          (@query.length == @suffix.length && is_exception?)
        )
    end
    alias_method :match?, :is_match?

    def get_domain
      if is_valid? && is_match? && idx = (@rule.index(:override) || @rule.index(:rest))
        @query[0..idx]
      else
        nil
      end
    end

    def get_subdomain
      if is_valid? && is_match? && idx = (@rule.index(:override) || @rule.index(:rest))
        sd = @query[(idx+1)..-1]
        sd.empty? ? nil : sd
      else
        nil
      end
    end

    def get_cookie
      if is_valid? && idx = (@rule.index(:override) || @rule.index(:rest))
        @query[0..idx]
      else
        nil
      end
    end

    def get_result
      @result = {}
      @result[:suffix]      = @suffix
      @result[:query]       = @query
      @result[:rule]        = @rule
      @result[:valid]       = @is_valid
      @result[:match]       = @is_match
      @result[:exactsuffix] = @is_exact_suffix
      @result[:domain]      = @domain
      @result[:subdomain]   = @subdomain
      @result[:cookie]      = @cookie
    end

    def values
      @result || get_result
    end

    def <=> other
      suffix_comp = self.values[:suffix].length <=> other.values[:suffix].length
      if suffix_comp == 0
        ec = 0
        ec =  1 if self.is_exception? && !other.is_exception?
        ec = -1 if other.is_exception? && !self.is_exception?
        ec
      else
        suffix_comp
      end
    end

  end

end