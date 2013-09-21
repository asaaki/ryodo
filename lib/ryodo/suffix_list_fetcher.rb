# encoding: utf-8

require "uri"
require "net/http"

module Ryodo

  class FetchError < StandardError; end

  class SuffixListFetcher

    def initialize uri = Ryodo::PUBLIC_SUFFIX_DATA_URI, store = Ryodo::PUBLIC_SUFFIX_STORE
      @uri = URI(uri)
      @store = store
    end

    def fetch_data
      res = Net::HTTP.get_response(@uri)
      raise Ryodo::FetchError, "Could not fetch suffix data! (#{res})" unless res.is_a?(Net::HTTPSuccess)
      @fetched_data = res.body.lines
    end

    def prepare_data
      @prepared_data = @fetched_data.inject([]) do |acc, line|
        next(acc) if line =~ /^\/\/|^\n/
        dns_line =  line.strip.
                      split(".").
                      reverse.
                      join(".") # "foo.bar.baz" => "baz.bar.foo"
        acc << dns_line
      end.sort
    end

    def save_data
      File.open(Ryodo::PUBLIC_SUFFIX_STORE, "w") do |fh|
        fh.write @prepared_data.join("\n")
      end if @prepared_data
    end

    class << self
      def fetch_and_save! uri = Ryodo::PUBLIC_SUFFIX_DATA_URI, store = Ryodo::PUBLIC_SUFFIX_STORE
        fetcher = self.new uri, store
        fetcher.fetch_data
        fetcher.prepare_data
        fetcher.save_data
        true
      rescue
        false
      end
    end

  end

end
