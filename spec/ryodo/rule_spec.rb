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
      [ ["jp"],                   ["jp","test"],                    [true, :rest] ],
      [ ["jp"],                   ["jp","test","www"],              [true, :rest, :rest] ],
      [ ["jp","tokyo","*"],       ["jp","test"],                    [true, false, false] ],
      [ ["jp","tokyo","*"],       ["jp","tokyo"],                   [true, true, :wildcard_false] ],
      [ ["jp","tokyo","*"],       ["jp","tokyo","metro"],           [true, true, :wildcard] ],
      [ ["jp","tokyo","*"],       ["jp","tokyo","foo","bar"],       [true, true, :wildcard, :rest] ],
      [ ["jp","tokyo","*"],       ["jp","tokyo","foo","bar","baz"], [true, true, :wildcard, :rest, :rest] ],
      [ ["jp","tokyo","!metro"],  ["jp","test"],                    [true, false, false] ],
      [ ["jp","tokyo","!metro"],  ["jp","tokyo"],                   [true, true, false] ],
      [ ["jp","tokyo","!metro"],  ["jp","tokyo","metro"],           [true, true, :override] ],
      [ ["jp","tokyo","!metro"],  ["jp","tokyo","metro","foo"],     [true, true, :override, :rest] ],
      [ ["jp"],                   ["de"],                           [false] ],
      [ ["jp"],                   ["de","test"],                    [false, false] ],
      [ ["jp"],                   ["de","test","www"],              [false, false, false] ],
      [ ["uk","co"],              ["uk"],                           [true, false] ],
      [ ["uk","co"],              ["uk","co"],                      [true, true] ],
      [ ["uk","co"],              ["uk","co","test"],               [true, true, :rest] ],
      [ ["uk","co"],              ["uk","co","test","www"],         [true, true, :rest, :rest] ]
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

end