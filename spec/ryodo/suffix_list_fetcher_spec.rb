# encoding: utf-8
require "ryodo/suffix_list_fetcher"
require File.expand_path("../../spec_helper.rb", __FILE__)

describe Ryodo::SuffixListFetcher do

  before do
    @custom_uri = "http://custom.suffix.list.example.com/foo-bar.dat"
    @custom_storage = "#{RYODO_TMP_ROOT}/custom-storage-path.dat"
  end

  after do
    Dir["#{RYODO_TMP_ROOT}/**/*"].each do |file|
      File.delete(file)
    end
  end

  it "#new creates a new instance with predefined vars" do
    fetcher = described_class.new

    fetcher.instance_variable_get("@uri").should   == URI(Ryodo::PUBLIC_SUFFIX_DATA_URI)
    fetcher.instance_variable_get("@store").should == Ryodo::PUBLIC_SUFFIX_STORE
  end

  it "#new creates a new instance with custom vars" do

    fetcher = described_class.new(@custom_uri, @custom_storage)

    fetcher.instance_variable_get("@uri").should   == URI(@custom_uri)
    fetcher.instance_variable_get("@store").should == @custom_storage
  end

  context "data retrieval and storage" do

    let(:fetcher){ described_class.new }

    it "#fetch_data retrieves remote data" do
      fetcher.fetch_data

      fetcher.instance_variable_get("@fetched_data").first.should =~ /BEGIN LICENSE BLOCK/
      fetcher.instance_variable_get("@fetched_data").first.should =~ /BEGIN ICANN DOMAINS/
      fetcher.instance_variable_get("@fetched_data").first.should =~ /BEGIN PRIVATE DOMAINS/
    end

    it "#save_data stores fetched data into file (as cleaned set)" do
      fetcher.fetch_data
      fetcher.instance_variable_set("@prepared_data", ["dummy data"])

      File.should_receive(:open).with(Ryodo::PUBLIC_SUFFIX_STORE,"w")
      fetcher.save_data
    end

    it "#prepare_data manipulates and cleans data for storage" do
      fetcher.fetch_data
      prepared_data = fetcher.prepare_data

      prepared_data.should be_an(Array)
      prepared_data.none?{|e| e =~ /^\/\//}.should be_true # no comment lines
      prepared_data.none?{|e| e =~ /^\n/}.should   be_true # no empty lines
    end

  end

  context ".fetch_and_save! does all jobs" do

    before do
      @valid_uri   = Ryodo::PUBLIC_SUFFIX_DATA_URI
      @invalid_uri = "#{Ryodo::PUBLIC_SUFFIX_DATA_URI}&invalid_file"
      @storage     = "#{RYODO_TMP_ROOT}/suffixes.dat"
    end

    it "and returns true if successful" do
      described_class.fetch_and_save!(@valid_uri, @storage).should be_true
    end

    it "and returns false if something failed" do
      described_class.fetch_and_save!(@invalid_uri, @storage).should be_false
    end

  end

end
