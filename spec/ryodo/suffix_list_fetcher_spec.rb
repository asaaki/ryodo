# frozen_string_literal: true

require 'ryodo/suffix_list_fetcher'
require 'spec_helper'

RSpec.describe Ryodo::SuffixListFetcher do
  subject { described_class }

  let(:custom_uri) { 'http://custom.suffix.list.example.com/foo-bar.dat' }
  let(:custom_storage) { "#{RYODO_TMP_ROOT}/custom-storage-path.dat" }

  after do
    Dir["#{RYODO_TMP_ROOT}/**/*"].each do |file|
      File.delete(file)
    end
  end

  it '#new creates a new instance with predefined vars' do
    fetcher = subject.new

    expect(fetcher.instance_variable_get('@uri')).to eq URI(Ryodo::PUBLIC_SUFFIX_DATA_URI)
    expect(fetcher.instance_variable_get('@store')).to be Ryodo::PUBLIC_SUFFIX_STORE
  end

  it '#new creates a new instance with custom vars' do
    fetcher = subject.new(custom_uri, custom_storage)

    expect(fetcher.instance_variable_get('@uri')).to eq URI(custom_uri)
    expect(fetcher.instance_variable_get('@store')).to be custom_storage
  end

  context 'data retrieval and storage' do
    let(:fetcher) { subject.new }

    it '#fetch_data retrieves remote data' do
      first_line = /This Source Code Form is subject to the terms of the Mozilla Public/
      fetcher.fetch_data

      expect(fetcher.instance_variable_get('@fetched_data').first).to match(first_line)
    end

    it '#save_data stores fetched data into file (as cleaned set)' do
      fetcher.fetch_data
      fetcher.instance_variable_set('@prepared_data', ['dummy data'])

      expect(File).to receive(:open).with(Ryodo::PUBLIC_SUFFIX_STORE, 'w')
      fetcher.save_data
    end

    it '#prepare_data manipulates and cleans data for storage' do
      fetcher.fetch_data
      prepared_data = fetcher.prepare_data

      expect(prepared_data).to be_an(Array)
      expect(prepared_data).not_to include(%r{\A//|\A\n})
    end
  end

  describe '.fetch_and_save! does all jobs' do
    let(:valid_uri)   { Ryodo::PUBLIC_SUFFIX_DATA_URI }
    let(:invalid_uri) { "#{Ryodo::PUBLIC_SUFFIX_DATA_URI}&invalid_file" }
    let(:storage)     { "#{RYODO_TMP_ROOT}/suffixes.dat" }

    it 'and returns true if successful' do
      expect(subject.fetch_and_save!(valid_uri, storage)).to be true
    end

    it 'and returns false if something failed' do
      expect(subject.fetch_and_save!(invalid_uri, storage)).to be false
    end
  end
end
