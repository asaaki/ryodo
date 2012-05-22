# encoding: utf-8
require File.expand_path("../../spec_helper.rb", __FILE__)

describe Ryodo::Rule do

  before do
    @item  = ["jp"]
    @query = ["jp","example"]
  end

  let(:rule){ described_class.new(@query) }

  it "#new needs a suffix list item" do
    expect{ described_class.new(@item) }.to_not raise_error
    expect{ described_class.new        }.to     raise_error
  end

  context "#query_mapper" do

    [
      [ ["jp"], ["jp","test"], [true, :registered] ],
      [ ["jp"], ["jp","test","www"], [true, :registered, :rest] ],
      [ ["jp","tokyo","*"], ["jp","test"], [true, false, false, false] ],
      [ ["jp","tokyo","*"], ["jp","tokyo"], [true, true, false, false] ],
      [ ["jp","tokyo","*"], ["jp","tokyo","metro"], [true, true, false, false] ],
      [ ["jp","tokyo","*"], ["jp","tokyo","foo","bar"], [true, true, :wildcard, :registered] ],
      [ ["jp","tokyo","*"], ["jp","tokyo","foo","bar","baz"], [true, true, :wildcard, :registered, :rest] ],
      [ ["jp","tokyo","!metro"], ["jp","test"], [true, false, false] ],
      [ ["jp","tokyo","!metro"], ["jp","tokyo"], [true, true, false] ],
      [ ["jp","tokyo","!metro"], ["jp","tokyo","metro"], [true, true, :override] ],
      [ ["jp","tokyo","!metro"], ["jp","tokyo","metro","foo"], [true, true, :override, :rest] ],
      [ ["jp"], ["de","test"], [false, false] ],
      [ ["jp"], ["de"],        [false, false] ]
    ].each do |current_rule, current_query, current_expectation|

      it "§( #{current_rule.reverse.join('.').rjust(15)} & #{current_query.reverse.join('.').ljust(20)} ) => #{current_expectation}" do
        rule = described_class.new(current_rule)
        mapped = rule.query_mapper(current_query)
        mapped.should == current_expectation
      end

    end

  end

  it "#match returns a match object" do
    match = described_class.new(["jp"]).match(["jp"])
    match.should be_kind_of(Ryodo::Match)
  end


  # context "#match (Ryodo::Match)" do
  #   it "single tld, simple domain" do
  #     i    = ["jp"]
  #     q    = ["jp","example"]
  #     rule = described_class.new(i)

  #     rule.match(q).should be_matched
  #   end

  #   it "single tld, simple tld (no match)" do
  #     i    = ["jp"]
  #     q    = ["jp"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "single tld, different tld (no match)" do
  #     i    = ["jp"]
  #     q    = ["de"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "long tld, simple domain" do
  #     i    = ["jp","co"]
  #     q    = ["jp","co","example"]
  #     rule = described_class.new(i)

  #     rule.match(q).should be_matched
  #   end

  #   it "long tld, simple tld (no match)" do
  #     i    = ["jp","co"]
  #     q    = ["jp","co"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "long tld, different tld (no match)" do
  #     i    = ["jp","co"]
  #     q    = ["jp","bar"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "long tld, too short tld (no match)" do
  #     i    = ["jp","co"]
  #     q    = ["jp"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "item => wildcard, query => domain" do
  #     i    = ["jp","*"]
  #     q    = ["jp","co","example"]
  #     rule = described_class.new(i)

  #     rule.match(q).should be_matched
  #   end

  #   it "item => wildcard, query => tld (no match)" do
  #     i    = ["jp","*"]
  #     q    = ["jp","co"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "item => wildcard, query => different tld (no match)" do
  #     i    = ["jp","co","*"]
  #     q    = ["jp","foo","bar"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "item => wildcard, query => too short tld (no match)" do
  #     i    = ["jp","co","*"]
  #     q    = ["jp","foo"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "item => override, query => domain" do
  #     i    = ["jp","!foo"]
  #     q    = ["jp","foo","example"]
  #     rule = described_class.new(i)

  #     rule.match(q).should be_matched
  #   end

  #   it "item => override, query => tld" do
  #     i    = ["jp","!foo"]
  #     q    = ["jp","foo"]
  #     rule = described_class.new(i)

  #     rule.match(q).should be_matched
  #   end

  #   it "item => override, query => different tld (no match)" do
  #     i    = ["jp","!foo"]
  #     q    = ["jp","bar","example"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  #   it "item => override, query => too short tld (no match)" do
  #     i    = ["jp","co","!foo"]
  #     q    = ["jp","co"]
  #     rule = described_class.new(i)

  #     rule.match(q).should_not be_matched
  #   end

  # end

end