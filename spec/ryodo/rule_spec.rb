# encoding: utf-8
require File.expand_path("../../spec_helper.rb", __FILE__)

describe Ryodo::Rule do

  before do
    @item  = ["jp"]
    @query = ["jp","example"]
  end

  let(:rule){ described_class.new(@query) }

  it "#new needs an suffix list item" do
    expect{ described_class.new(@item) }.to_not raise_error
    expect{ described_class.new        }.to     raise_error
  end


  context "#match (Ryodo::Match)" do
    it "single tld, simple domain" do
      i    = ["jp"]
      q    = ["jp","example"]
      rule = described_class.new(i)

      rule.match(q).should be_matched
    end

    it "single tld, simple tld (no match)" do
      i    = ["jp"]
      q    = ["jp"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "single tld, different tld (no match)" do
      i    = ["jp"]
      q    = ["de"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "long tld, simple domain" do
      i    = ["jp","co"]
      q    = ["jp","co","example"]
      rule = described_class.new(i)

      rule.match(q).should be_matched
    end

    it "long tld, simple tld (no match)" do
      i    = ["jp","co"]
      q    = ["jp","co"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "long tld, different tld (no match)" do
      i    = ["jp","co"]
      q    = ["jp","bar"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "long tld, too short tld (no match)" do
      i    = ["jp","co"]
      q    = ["jp"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "item => wildcard, query => domain" do
      i    = ["jp","*"]
      q    = ["jp","co","example"]
      rule = described_class.new(i)

      rule.match(q).should be_matched
    end

    it "item => wildcard, query => tld (no match)" do
      i    = ["jp","*"]
      q    = ["jp","co"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "item => wildcard, query => different tld (no match)" do
      i    = ["jp","co","*"]
      q    = ["jp","foo","bar"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "item => wildcard, query => too short tld (no match)" do
      i    = ["jp","co","*"]
      q    = ["jp","foo"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "item => override, query => domain" do
      i    = ["jp","!foo"]
      q    = ["jp","foo","example"]
      rule = described_class.new(i)

      rule.match(q).should be_matched
    end

    it "item => override, query => tld" do
      i    = ["jp","!foo"]
      q    = ["jp","foo"]
      rule = described_class.new(i)

      rule.match(q).should be_matched
    end

    it "item => override, query => different tld (no match)" do
      i    = ["jp","!foo"]
      q    = ["jp","bar","example"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

    it "item => override, query => too short tld (no match)" do
      i    = ["jp","co","!foo"]
      q    = ["jp","co"]
      rule = described_class.new(i)

      rule.match(q).should_not be_matched
    end

  end

end