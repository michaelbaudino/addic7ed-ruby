require "spec_helper"

describe Addic7ed::NormalizeVersion do
  def normalized_version(version)
    described_class.call(version)
  end

  it "upcases everything" do
    expect(normalized_version("DiMENSiON")).to eq "DIMENSION"
  end

  it "removes white spaces and line breaks and non-breaking spaces" do
    expect(normalized_version(" \n DIMENSION \u00a0 ")).to eq "DIMENSION"
  end

  it "removes the filesize" do
    expect(normalized_version("DIMENSION, 0.00 MBs")).to eq "DIMENSION"
  end

  it "removes heading or trailing dots" do
    expect(normalized_version(".DIMENSION.")).to eq "DIMENSION"
  end

  it "removes heading or trailing whitespaces" do
    expect(normalized_version(" DIMENSION ")).to eq "DIMENSION"
  end

  it "removes heading or trailing dashes" do
    expect(normalized_version("-DIMENSION-")).to eq "DIMENSION"
  end

  it "removes '720p' tag" do
    expect(normalized_version("720P DIMENSION")).to eq "DIMENSION"
  end

  it "removes '1080p' tag" do
    expect(normalized_version("1080P DIMENSION")).to eq "DIMENSION"
  end

  it "removes 'HDTV' tag" do
    expect(normalized_version("HDTV DIMENSION")).to eq "DIMENSION"
  end

  it "removes 'x264' tag" do
    expect(normalized_version("X264 DIMENSION")).to eq "DIMENSION"
    expect(normalized_version("X.264 DIMENSION")).to eq "DIMENSION"
  end

  it "removes 'PROPER' tag" do
    expect(normalized_version("PROPER DIMENSION")).to eq "DIMENSION"
  end

  it "removes 'RERIP' tag" do
    expect(normalized_version("RERIP DIMENSION")).to eq "DIMENSION"
  end

  it "removes 'INTERNAL' tag" do
    expect(normalized_version("INTERNAL DIMENSION")).to eq "DIMENSION"
  end

  it "removes the 'Version' prefix" do
    expect(normalized_version("Version DIMENSION")).to eq "DIMENSION"
  end

  it "removes combined tags" do
    expect(normalized_version("Version 720P PROPER X264 HDTV DIMENSION")).to eq "DIMENSION"
  end

  it "supports multiple concatenated versions" do
    expect(normalized_version("-TLA, -FoV")).to eq "TLA,FOV"
  end
end
