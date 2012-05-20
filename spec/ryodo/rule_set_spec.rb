# encoding: utf-8
require File.expand_path("../../spec_helper.rb", __FILE__)

describe Ryodo::RuleSet do

  before do
    @query = "jp"
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

  it "#find_rules collects matching list items for one level (always first level)" do
    rule = Ryodo::Rule.new(["jp"])

    Ryodo::Rule.should_receive(:new).and_return(rule)
    ruleset.find_rules.should == [rule]
  end

  it "#apply! returns a set of rules" do
    applied = ruleset.apply!
    applied.should be_kind_of(Array)
    applied.all?{|e| e.is_a?(Ryodo::Rule)}.should be_true
  end

end