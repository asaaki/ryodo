# frozen_string_literal: true
require 'forwardable'

module Ryodo
  class SuffixList
    attr_reader :suffix_data

    def initialize(suffix_file = Ryodo::PUBLIC_SUFFIX_STORE)
      load_file(suffix_file)
    end

    def parse_data
      File.readlines(@suffix_file).map { |line| line.strip.split('.') }
    end

    def load_file(suffix_file = Ryodo::PUBLIC_SUFFIX_STORE)
      @suffix_file = suffix_file
      @suffix_data = parse_data << ['example']
    end

    alias list suffix_data

    def inspect
      "#<#{self.class} FILE:#{@suffix_file} ENTRIES:#{@suffix_data.size}>"
    end

    class << self
      extend Forwardable

      # rubocop:disable Style/MethodName
      def SuffixList(suffix_file = Ryodo::PUBLIC_SUFFIX_STORE)
        instance(suffix_file)
      end
      # rubocop:enable Style/MethodName

      def reload(suffix_file = Ryodo::PUBLIC_SUFFIX_STORE)
        instance.load_file(suffix_file) && true
      end

      def instance
        @instance ||= new
      end

      delegate [:list, :inspect] => :instance
    end

    private_class_method :new
  end
end
