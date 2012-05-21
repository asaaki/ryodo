# encoding: utf-8
require File.expand_path("../../spec_helper.rb", __FILE__)

describe Ryodo::Query do

  before do
    @raw_query = "example.jp"
    @query     = ["jp","example"]
  end

  let(:rquery) { described_class.new(@raw_query) }

  it "creates a new query instance" do
    query = described_class.new(@raw_query)
    query.instance_variables.should include(:@query)
  end

  context "#new raises" do

    it "if no query is given" do
      expect{ described_class.new }.to raise_error
    end

    it "if query is nil" do
      expect{ described_class.new(nil) }.to raise_error(Ryodo::QueryError)
    end

    it "if query is an empty string" do
      expect{ described_class.new("") }.to raise_error(Ryodo::QueryError)
    end

    it "if query is not a string" do
      expect{ described_class.new([]) }.to raise_error(Ryodo::QueryError)
    end

  end

  context "#build_query sets a query array which is easily applyable" do
    it "single TLD" do
      raw_query = "jp"
      obj = described_class.new(raw_query)
      obj.instance_variable_get(:@query).should == ["jp"]
    end

    it "simple domain (example.com)" do
      raw_query = "example.com"
      obj = described_class.new(raw_query)
      obj.instance_variable_get(:@query).should == ["com", "example"]
    end

    it "domain + subdomain (www.example.com)" do
      raw_query = "www.example.com"
      obj = described_class.new(raw_query)
      obj.instance_variable_get(:@query).should == ["com", "example", "www"]
    end

    it "FQDN (www.example.com.)" do
      raw_query = "www.example.com."
      obj = described_class.new(raw_query)
      obj.instance_variable_get(:@query).should == ["com", "example", "www"]
    end

    it "FQDN, reverse order (.com.example.www)" do
      raw_query = ".com.example.www"
      obj = described_class.new(raw_query)
      obj.instance_variable_get(:@query).should == ["com", "example", "www"]
    end

  end

  context "#get_rule_set" do

    before do
      @list = [["de"],["jp"],["com"]]
    end

    it "reads the SuffixList" do
      Ryodo::SuffixList.should_receive(:list)
      Ryodo::RuleSet.stub(:new)
      rquery.get_rule_set
    end

    it "returns a RuleSet" do
      Ryodo::SuffixList.stub(:list).and_return(@list)

      Ryodo::RuleSet.should_receive(:new).with(@query,@list).and_return("rule_set object")
      rquery.get_rule_set.should == "rule_set object"
    end

  end

  it "#apply_rule_set returns the set of valid matches" do
    matches = rquery.apply_rule_set

    matches.should be_kind_of(Array)
    matches.all?{|e| e.is_a?(Ryodo::Match)}.should be_true
  end

  it "#apply_rule_set is empty if no match found (invalid domain)" do
    obj = described_class.new("invalid.void")

    obj.apply_rule_set.should == []
  end

  it "#apply_rule_set is empty if no match found (rules could not be applied)" do
    obj = described_class.new("asaaki.tokyo.jp")

    obj.apply_rule_set.should == []
  end

  it "#best_match returns match with highest prio" do
    # www.test.k12.ak.us => returns 3 matches with different prios
    obj = described_class.new("www.test.k12.ak.us")
    obj.best_match.result[:domain].should == ["us","ak","k12","test"]
  end

  it "#best_match returns match with highest prio (wildcard check)" do
    # *.tokyo.jp
    obj = described_class.new("asaaki.out-of.tokyo.jp")
    obj.best_match.result[:domain].should == ["jp","tokyo","out-of","asaaki"]
  end

  it "#best_match does not return low prio match if high prio match failed" do
    # *.tokyo.jp
    # <domain>.tokyo.jp should NOT return a valid match
    obj = described_class.new("asaaki.tokyo.jp")
    obj.best_match.should be_nil
  end

  it "#best_match returns match with highest prio (wildcard vs override)" do
    # !metro.tokyo.jp vs. *.tokyo.jp
    # best match is result with the shortest cookie domain
    obj = described_class.new("asaaki.metro.tokyo.jp")
    obj.best_match.result[:domain].should == ["jp","tokyo","metro","asaaki"]
    obj.best_match.result[:cookie].should == ["jp","tokyo","metro"]
  end

  it "#best_match returns exceptional match" do
    # !metro.tokyo.jp vs. *.tokyo.jp
    # also metro.tokyo.jp is allowed! (exception rule)
    obj = described_class.new("metro.tokyo.jp")
    obj.best_match.result[:domain].should == ["jp","tokyo","metro"]
    obj.best_match.result[:cookie].should == ["jp","tokyo","metro"]
  end

  it "#run queries the list and return the result" do
    pending "not yet implemented"
  end

end