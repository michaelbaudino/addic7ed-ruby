require "spec_helper"

describe Addic7ed::CheckCompatibility, "#call(subtitle, group)" do
  let(:subtitle) { Addic7ed::Subtitle.new(version: "DIMENSION") }
  let(:group)    { subtitle.version }

  subject { described_class.call(subtitle, group) }

  context "when group is matching exactly" do
    let(:group) { subtitle.version }

    it "returns true" do
      expect(subject).to be true
    end
  end

  context "when group is one of the multiple groups defined for subtitle" do
    let(:subtitle) { Addic7ed::Subtitle.new(version: "DIMENSION,FOV") }
    let(:group)    { "FOV" }

    it "returns true" do
      expect(subject).to be true
    end
  end

  context "when group is the generally compatible 720p version of the subtitle" do
    let(:group) { "LOL" }

    it "returns true" do
      expect(subject).to be true
    end
  end

  context "when group is the generally compatible low-def version of the subtitle" do
    let(:subtitle) { Addic7ed::Subtitle.new(version: "LOL") }
    let(:group)    { "DIMENSION" }

    it "returns true" do
      expect(subject).to be true
    end
  end

  context "when group is different" do
    let(:group) { "EVOLVE" }

    it "returns false" do
      expect(subject).to be false
    end
  end

  context "when subtitle has a compatibility comment" do
    let(:subtitle) { Addic7ed::Subtitle.new(version: "DIMENSION", comment: "Works with FOV") }

    context "when group is mentioned in the comment" do
      let(:group) { "FOV" }

      it "returns true" do
        expect(subject).to be true
      end
    end

    context "when group is not mentioned in the comment" do
      let(:group) { "EVOLVE" }

      it "returns false" do
        expect(subject).to be false
      end
    end
  end

  context "when subtitle has an incompatibility comment" do
    let(:subtitle) { Addic7ed::Subtitle.new(version: "DIMENSION", comment: "Doesn't work for FOV") }
    let(:group)    { "FOV" }

    it "returns false" do
      expect(subject).to be false
    end
  end

  context "when subtitle has an ambiguous comment" do
    let(:subtitle) { Addic7ed::Subtitle.new(version: "DIMENSION", comment: "Resync of FOV") }
    let(:group)    { "FOV" }

    it "returns false" do
      expect(subject).to be false
    end
  end
end
