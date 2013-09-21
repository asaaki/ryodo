# encoding: utf-8

module Ryodo

  class SuffixList
    def initialize suffix_file = Ryodo::PUBLIC_SUFFIX_STORE
      load_file(suffix_file)
    end

    def parse_data
      # loads and converts to array
      # "baz.bar.foo" => ["baz", "bar", "foo"]
      File.readlines(@suffix_file).map{ |line| line.strip.split(".") }
    end

    def load_file suffix_file = Ryodo::PUBLIC_SUFFIX_STORE
      @suffix_file = suffix_file
      @suffix_data = parse_data
    end

    def list
      @suffix_data
    end

    def inspect
      "#<#{self.class} FILE:#{@suffix_file} ENTRIES:#{@suffix_data.size}>"
    end

    class << self

      def SuffixList suffix_file = Ryodo::PUBLIC_SUFFIX_STORE
        instance(suffix_file)
      end

      def reload suffix_file = Ryodo::PUBLIC_SUFFIX_STORE
        instance.load_file(suffix_file) && true
      end

      def list
        instance.list
      end

      def instance
        @@instance ||= new
      end

      def inspect
        instance.inspect
      end

    end

    private_class_method :new

  end

end
