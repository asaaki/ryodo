# encoding: utf-8
require File.expand_path("../../spec_helper.rb", __FILE__)

describe Ryodo::SuffixList do

  context "singleton" do

    it "cannot be instanciated via #new" do
      expect{ described_class.new }.to raise_error
    end

    it "creates instance by calling the class itself" do
      described_class.should_receive(:instance)
      described_class.send(:"SuffixList")
    end

    it "instance check" do
      o1 = described_class
      o2 = described_class

      o1.should == o2
    end

    it "has .instance" do
      described_class.methods.should include(:"instance")
    end

  end

  context "methods" do

    let(:described_instance){ described_class.instance }

    it ".reload can retrieve a fresh suffix list" do
      described_instance.should_receive(:load_file).and_return(true)
      described_class.reload
    end

    it ".reload fails if given file doesn't exist" do
      expect { described_class.reload("#{RYODO_TMP_ROOT}/invalid-file.dat") }.to raise_error
    end

    it ".list returns an array of arrays" do
      described_class.list.should be_kind_of(Array)
      described_class.list.any?{|e|e.is_a?(Array)}.should be_true
    end

  end

end
