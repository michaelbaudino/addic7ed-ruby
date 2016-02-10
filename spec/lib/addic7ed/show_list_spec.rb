require "spec_helper"
require "./lib/addic7ed"

describe Addic7ed::ShowList, ".url_segment_for" do
  it "changes all spaces to underscores" do
    expect(Addic7ed::ShowList.url_segment_for("The.Walking.Dead")).to eq "The_Walking_Dead"
  end

  it "wraps country code with parenthesis" do
    expect(Addic7ed::ShowList.url_segment_for("Shameless.US")).to eq "Shameless_(US)"
    expect(Addic7ed::ShowList.url_segment_for("Vikings.UK")).to eq "Vikings_(UK)"
  end

  it "is case-insensitive" do
    expect(Addic7ed::ShowList.url_segment_for("shameless.us")).to eq "Shameless_(US)"
  end

  it "wraps production year with parenthesis" do
    expect(Addic7ed::ShowList.url_segment_for("Vikings.2013")).to eq "Vikings_(2013)"
  end

  it "returns last show when production year is unspecified" do
    expect(Addic7ed::ShowList.url_segment_for("Empire")).to eq "Empire_(2015)"
    expect(Addic7ed::ShowList.url_segment_for("American.Crime")).to eq "American_Crime_(2015)"
  end

  it "handles when both country code and production year are present" do
    expect(Addic7ed::ShowList.url_segment_for("Legacy.2013.UK")).to eq "Legacy_(2013)_(UK)"
  end

  it "handles when show name contains a quote" do
    expect(Addic7ed::ShowList.url_segment_for("Greys.Anatomy")).to eq "Grey's_Anatomy"
  end

  it "handles when a show name contains dots" do
    expect(Addic7ed::ShowList.url_segment_for("The.O.C.")).to eq "The_O.C."
  end

  it "raises a ShowNotFound error when no matching show is found" do
    expect{Addic7ed::ShowList.url_segment_for("Not.an.existing.show")}.to raise_error Addic7ed::ShowNotFound
  end
end
