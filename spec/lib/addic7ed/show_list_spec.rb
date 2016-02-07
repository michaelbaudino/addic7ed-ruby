require "spec_helper"
require "./lib/addic7ed"

describe Addic7ed::ShowList, "#find" do
  it "changes all spaces to underscores" do
    expect(Addic7ed::ShowList.find("Show Name")).to eq "Show_Name"
  end

  it "wraps country code with parenthesis" do
    expect(Addic7ed::ShowList.find("Showname.US")).to eq "Showname_(US)"
  end

  it "detects country code even in lowercase" do
    expect(Addic7ed::ShowList.find("showname.us")).to eq "showname_(us)"
  end

  it "removes country code for the original show when it's UK" do
    expect(Addic7ed::ShowList.find("Showname.UK")).to eq "Showname"
  end

  it "removes production year" do
    expect(Addic7ed::ShowList.find("Showname.2014")).to eq "Showname"
  end

  it "handles when both country code and production year are present" do
    expect(Addic7ed::ShowList.find("Showname.2014.UK")).to eq "Showname"
    expect(Addic7ed::ShowList.find("Showname.UK.2014")).to eq "Showname"
    expect(Addic7ed::ShowList.find("Showname.2014.US")).to eq "Showname_(US)"
    expect(Addic7ed::ShowList.find("Showname.US.2014")).to eq "Showname_(US)"
  end
end
