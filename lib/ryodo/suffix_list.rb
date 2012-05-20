# encoding: utf-8

module Ryodo

  class SuffixList
    def initialize suffix_file = Ryodo::PUBLIC_SUFFIX_STORE
      load_file suffix_file
      true
    end

    def parse_data
      # loads and converts to array
      # "baz.bar.foo" => ["baz", "bar", "foo"]
      @suffix_data = File.readlines(@suffix_file).map{ |line| line.strip.split(".") }
    end

    def load_file suffix_file = Ryodo::PUBLIC_SUFFIX_STORE
      @suffix_file = suffix_file
      parse_data
    end

    def inspect
      "#<#{self.class}:0x%014x FILE:#{@suffix_file} SET_SIZE:#{@suffix_data.size}>" % (self.__id__ * 2)
    end

  end

end