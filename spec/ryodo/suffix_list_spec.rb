require "spec_helper"

describe Ryodo::SuffixList do
  context "singleton" do

    it "cannot be instanciated via #new" do
      expect{ described_class.new }.to raise_error
    end

    it "creates instance by calling the class itself" do
      described_class.should_receive(:instance)
      described_class.send(:"SuffixList")
    end

    it "has .instance" do
      expect(described_class.methods).to include(:instance)
    end

    it "instance check" do
      o1 = described_class.instance
      o2 = described_class.instance

      expect(o1).to be o2
    end
  end

  context "methods" do
    let(:described_instance) { described_class.instance }

    it ".reload can retrieve a fresh suffix list" do
      expect(described_instance).to receive(:load_file).and_return(true)
      described_class.reload
    end

    it ".reload fails if given file doesn't exist" do
      expect { described_class.reload("#{RYODO_TMP_ROOT}/invalid-file.dat") }.to raise_error
    end

    it ".list returns an array of arrays" do
      expect(described_class.list).to be_an(Array)
      expect(
        described_class.list.all? { |e| e.is_a?(Array) }
      ).to be true
    end
  end
end
