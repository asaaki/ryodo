# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'ryodo'

module Ryodo
  FetchError = Class.new(StandardError)

  class SuffixListFetcher
    SKIPPABLE_LINE_REGEXP = %r{\A//|\A\n}.freeze

    class << self
      def fetch_and_save!(uri = Ryodo::PUBLIC_SUFFIX_DATA_URI, store = Ryodo::PUBLIC_SUFFIX_STORE)
        puts 'Fetch, process and save public suffix data ...'
        new(uri, store).tap do |fetcher|
          fetcher.fetch_data
          fetcher.prepare_data
          fetcher.save_data
        end
        puts '--- done.'
        true
      rescue StandardError
        puts 'Something went wrong'
        false
      end
    end

    def initialize(uri = Ryodo::PUBLIC_SUFFIX_DATA_URI, store = Ryodo::PUBLIC_SUFFIX_STORE)
      @uri = URI.parse(uri)
      @store = store
    end

    def fetch_data
      response = Net::HTTP.get_response(@uri)
      raise Ryodo::FetchError, "Could not fetch suffix data! (#{response})" unless response.is_a?(Net::HTTPSuccess)

      @fetched_data = response.body.lines
    end

    def prepare_data
      @prepared_data = @fetched_data.inject([]) do |acc, line|
        # Using `Regexp#===` instead of `.match?`, to be compatible with Ruby 2.3 and older
        next(acc) if SKIPPABLE_LINE_REGEXP === line # rubocop:disable Style/CaseEquality

        acc << reverse_dn(line)
      end.sort
    end

    def save_data
      return unless @prepared_data

      File.open(Ryodo::PUBLIC_SUFFIX_STORE, 'w') do |fh|
        fh.write @prepared_data.join("\n")
      end
    end

    private

    def reverse_dn(domain_name)
      # "foo.bar.baz" => "baz.bar.foo"
      domain_name.strip.split('.').reverse.join('.')
    end
  end
end
