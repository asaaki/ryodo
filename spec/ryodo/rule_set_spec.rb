# encoding: utf-8
require File.expand_path("../../spec_helper.rb", __FILE__)

describe Ryodo::RuleSet do

  before do
    @query = ["jp","example","www"]
    @list = [["de"],["jp"],["com"]]
  end

  let(:ruleset){ described_class.new(@query,@list) }

  it "#new creates a new rule set based on query and list" do

    obj = described_class.new(@query, @list)
    obj.instance_variable_get(:@query).should == @query
    obj.instance_variable_get(:@list).should == @list
  end

  it "#new uses per default the SuffixList.list" do
    Ryodo::SuffixList.should_receive(:list).and_return(@list)

    obj = described_class.new(@query)
    obj.instance_variable_get(:@list).should == @list
  end

  it "#find_rules collects matching list items" do
    rules = ruleset.find_rules

    rules.should be_kind_of(Array)
    rules.all?{|e| e.is_a?(Ryodo::Rule)}.should be_true
  end

  it "#find_rules is empty if absolutely no rules could be found" do
    obj = described_class.new(@query,[["uk"],["us"]])
    rules = obj.find_rules

    rules.should == []
  end

  it "#matches collects valid matches only" do
    matches = ruleset.matches

    matches.should be_kind_of(Hash)
    matches.keys.should include(:matches)
    matches.keys.should include(:exception)
    matches.keys.should include(:wildcard)
    matches.keys.should include(:exact_suffix)
  end

  # Ryodo::RuleSet#find_best_match is deeply checked via checks/matching.rb
  # here only basic expecations are tested

  it "#find_best_match returns a valid match" do
    ruleset.find_best_match.should be_kind_of(Ryodo::Match)
  end

  it "#find_best_match returns nil, if no match was found" do
    obj = described_class.new(["invalid","query"])
    obj.find_best_match.should be_nil
  end

end