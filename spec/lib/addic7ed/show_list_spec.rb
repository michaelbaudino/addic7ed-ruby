require "spec_helper"
require "./lib/addic7ed"

describe Addic7ed::ShowList, ".find" do
  it "changes all spaces to underscores" do
    expect(Addic7ed::ShowList.find("The Walking Dead")).to eq "The_Walking_Dead"
  end

  it "wraps country code with parenthesis" do
    expect(Addic7ed::ShowList.find("Shameless.US")).to eq "Shameless_(US)"
    expect(Addic7ed::ShowList.find("Vikings.UK")).to eq "Vikings_(UK)"
  end

  it "detects country code even in lowercase" do
    expect(Addic7ed::ShowList.find("shameless.us")).to eq "Shameless_(US)"
  end

  it "sets production year between parenthesis" do
    expect(Addic7ed::ShowList.find("Vikings.2013")).to eq "Vikings_(2013)"
  end

  it "handles when both country code and production year are present" do
    expect(Addic7ed::ShowList.find("Legacy.2013.UK")).to eq "Legacy_(2013)_(UK)"
  end

  it "handles when show name contains a quote" do
    expect(Addic7ed::ShowList.find("Greys.Anatomy")).to eq "Grey's_Anatomy"
  end

  it "raises a ShowNotFound error when no matching show is found" do
    expect{Addic7ed::ShowList.find("Not an existing show")}.to raise_error Addic7ed::ShowNotFound
  end
end
