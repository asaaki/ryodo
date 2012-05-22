# encoding: utf-8

module Ryodo

  class Rule

    def initialize item
      @item = item
      @item << :needed unless @item.last[0] == "!"
    end

    def query_mapper query
      query.map!{|e| e.to_s.downcase }
      last_value = true
      res = @item.map.with_index do |label, index|
        this_value = if last_value # fails if previous label already failed
          case label
          when "*"
            if query[index].nil? || query[index+1].nil?
              false
            else
              :wildcard
            end
          when /^\!.*/
            if query[index].nil?
              false
            elsif query[index] != label[1..-1]
              :override_false
            else
              :override
            end
          when :needed
            query[index].nil? ? false : :registered
          else
            query[index] == label
          end
        else
          false # following elements will always fail, of course
        end
        last_value = this_value
      end

      # fill up to the length of query
      # (mappers have to be same length)
      res = res.fill(:rest, res.length..(query.length-1)) if res.length < query.length
      res
    end

    def match query
      mapper = query_mapper(query)
      Ryodo::Match.new(@item, mapper, query)
    end

  end

end
