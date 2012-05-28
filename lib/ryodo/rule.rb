# encoding: utf-8

module Ryodo

  class Rule

    def initialize suffix
      @suffix = suffix
      #@suffix << :suffix if @suffix.last == "*"
    end

    def query_mapper query
      query.map!{|e| e.to_s.downcase }
      last_value = true

      rule = @suffix.map.with_index do |label, index|

        this_value = if last_value # fails if previous label already failed

          case label
          when "*"
            if query[index].nil? # || query[index+1].nil?
              :wildcard_false
            else
              :wildcard
            end
          when :suffix
            if query[index].nil?
              false
            else
              :rest
            end
          when /^\!.*/
            if query[index].nil? || query[index] != label[1..-1]
              false
            # elsif query[index] != label[1..-1]
            #   :override_false
            else
              :override
            end
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
      filler = rule.include?(false) ? false : :rest
      rule = rule.fill(filler, rule.length..(query.length-1)) if rule.length < query.length
      rule
    end

    def match query
      mapped_rule = query_mapper(query)
      Ryodo::Match.new(@suffix, query, mapped_rule)
    end

  end

end
