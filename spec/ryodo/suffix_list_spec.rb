# frozen_string_literal: true

require "spec_helper"

RSpec.describe Ryodo::SuffixList do
  subject { described_class }

  context "singleton" do
    it "cannot be instanciated via #new" do
      expect { subject.new }.to raise_error(NoMethodError)
    end

    it "creates instance by calling the class itself" do
      expect(subject).to receive(:instance)
      subject.send(:SuffixList)
    end

    it "has .instance" do
      expect(subject.methods).to include(:instance)
    end

    it "instance check" do
      o1 = subject.instance
      o2 = subject.instance

      expect(o1).to be(o2)
    end
  end

  context "methods" do
    let(:described_instance) { subject.instance }

    it ".reload can retrieve a fresh suffix list" do
      expect(described_instance).to receive(:load_file).and_return(true)
      subject.reload
    end

    it ".reload fails if given file doesn't exist" do
      expect { subject.reload("#{RYODO_TMP_ROOT}/invalid-file.dat") }.to raise_error(Errno::ENOENT)
    end

    it ".list returns an array of arrays" do
      expect(subject.list).to be_an(Array)
      expect(subject.list.all? { |e| e.is_a?(Array) }).to be(true)
    end
  end
end
