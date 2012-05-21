# encoding: utf-8

module Ryodo

  class Rule

    def initialize item
      @item = item
      self
    end

    def match query
      query.map!{|e| e.to_s.downcase }
      res = @item.map.with_index do |elem, index|
        case elem
        when "*"
          !query[index].nil? ? :wildcard : false
        when /^\!.*/
          query[index] == elem[1..-1] ? :override : false
        else
          query[index] == elem
        end
      end

      # fill up to the length of query
      res = res.fill(:rest, res.length..(query.length-1)) if res.length < query.length

      matched = if res[1..-1].uniq.include?(false) || !res.include?(:rest)
        Ryodo::NoMatch.new(res, query)
      else
        Ryodo::Match.new(res, query)
      end
      matched
    end

  end

end