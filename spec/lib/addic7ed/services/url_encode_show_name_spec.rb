require "spec_helper"

describe Addic7ed::URLEncodeShowName do
  it "changes all spaces to underscores" do
    expect(described_class.call("The.Walking.Dead")).to eq "The_Walking_Dead"
  end

  it "wraps country code with parenthesis" do
    expect(described_class.call("Shameless.US")).to eq "Shameless_(US)"
    expect(described_class.call("Vikings.UK")).to eq "Vikings_(UK)"
  end

  it "is case-insensitive" do
    expect(described_class.call("shameless.us")).to eq "Shameless_(US)"
  end

  it "wraps production year with parenthesis" do
    expect(described_class.call("Vikings.2013")).to eq "Vikings_(2013)"
  end

  it "returns last show when production year is unspecified" do
    expect(described_class.call("Empire")).to eq "Empire_(2015)"
    expect(described_class.call("American.Crime")).to eq "American_Crime_(2015)"
  end

  it "handles when both country code and production year are present" do
    expect(described_class.call("Legacy.2013.UK")).to eq "Legacy_(2013)_(UK)"
  end

  it "handles when show name contains a quote" do
    expect(described_class.call("Greys.Anatomy")).to eq "Grey's_Anatomy"
  end

  it "handles when a show name contains dots" do
    expect(described_class.call("The.O.C.")).to eq "The_O.C."
  end

  it "raises a ShowNotFound error when no matching show is found" do
    expect{described_class.call("Not.an.existing.show")}.to raise_error Addic7ed::ShowNotFound
  end
end
