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
    obj = described_class.new(@query,["uk","us"])
    rules = obj.find_rules

    rules.should == []
  end

  it "#find_matches collects valid matches only" do
    ruleset.find_rules
    matches = ruleset.find_matches

    matches.should be_kind_of(Array)
    matches.all?{|e| e.is_a?(Ryodo::Match)}.should be_true
    matches.none?{|e| e.is_a?(Ryodo::NoMatch)}.should be_true
  end

  it "#apply runs rule and match finder" do
    ruleset.should_receive(:find_rules)
    ruleset.should_receive(:find_matches)
    ruleset.apply
  end

end