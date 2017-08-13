# frozen_string_literal: true

require "spec_helper"

describe Addic7ed::VideoFile do
  let(:file) { Addic7ed::VideoFile.new(filename) }

  shared_examples "a media file" do |filename, expected_show_name|
    let(:filename) { filename }

    it "it detects successfully" do
      expect(file.showname).to eq(expected_show_name || "Showname")
      expect(file.season).to eq 2
      expect(file.episode).to eq 1
      expect(file.tags).to eq %w[720P HDTV X264]
      expect(file.group).to eq "GROUP"
      expect(file.distribution).to(satisfy { |d| ["", "DISTRIBUTION"].include?(d) })
    end
  end

  shared_examples "an unknown file" do |filename|
    let(:filename) { filename }

    it "raises an error" do
      expect { file }.to raise_error Addic7ed::InvalidFilename
    end
  end

  describe "#initialize" do
    context "with regular notation" do
      it_behaves_like "a media file", "Showname.S02E01.720p.HDTV.x264-GROUP.mkv"
    end

    context "with x notation" do
      it_behaves_like "a media file", "Showname.02x01.720p.HDTV.x264-GROUP.mkv"
    end

    context "with 3-digits notation" do
      it_behaves_like "a media file", "Showname.201.720p.HDTV.x264-GROUP.mkv"
    end

    context "with brackets notation" do
      it_behaves_like "a media file", "Showname.[S02E01].720p.HDTV.x264-GROUP.mkv"
    end

    context "with brackets and x notation" do
      it_behaves_like "a media file", "Showname.[2x01].720p.HDTV.x264-GROUP.mkv"
    end

    context "with brackets and 3-digits notation" do
      it_behaves_like "a media file", "Showname.[201].720p.HDTV.x264-GROUP.mkv"
    end

    context "with brackets and x notation and space separator" do
      it_behaves_like "a media file", "Showname [2x01] 720p.HDTV.x264-GROUP.mkv"
    end

    context "with brackets and 3-digits notation and space separator" do
      it_behaves_like "a media file", "Showname [201] 720p.HDTV.x264-GROUP.mkv"
    end

    context "with lowercase filename" do
      it_behaves_like "a media file", "showname.s02e01.720p.HDTV.x264-group.mkv", "showname"
    end

    context "with multiple words in show name" do
      it_behaves_like "a media file", "Show.Name.S02E01.720p.HDTV.x264-GROUP.mkv", "Show.Name"
    end

    context "with multiple words in show name separated by spaces" do
      it_behaves_like "a media file", "Show Name.S02E01.720p.HDTV.x264-GROUP.mkv", "Show Name"
    end

    context "with only numbers in show name" do
      it_behaves_like "a media file", "42.S02E01.720p.HDTV.x264-GROUP.mkv", "42"
    end

    context "with production year" do
      it_behaves_like "a media file",
                      "Showname.2014.S02E01.720p.HDTV.x264-GROUP.mkv",
                      "Showname.2014"
    end

    context "with an optional distribution group name" do
      it_behaves_like "a media file",
                      "Showname.2014.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv",
                      "Showname.2014"
    end

    context "with a full path" do
      it_behaves_like "a media file", "/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP.mkv"
    end

    context "with a relative path" do
      it_behaves_like "a media file", "../path/to/Showname.S02E01.720p.HDTV.x264-GROUP.mkv"
    end

    context "without extension" do
      it_behaves_like "a media file", "Showname.S02E01.720p.HDTV.x264-GROUP"
    end

    context "with a double episode" do
      it_behaves_like "a media file", "Showname.S02E0102.720p.HDTV.x264-GROUP.mkv"
    end

    context "with a double episode" do
      it_behaves_like "a media file", "Showname.S02E01E02.720p.HDTV.x264-GROUP.mkv"
    end

    context "with a double episode with dash separator" do
      it_behaves_like "a media file", "Showname.S02E01-02.720p.HDTV.x264-GROUP.mkv"
    end

    context "with no showname" do
      it_behaves_like "an unknown file", ".S02E01.720p.HDTV.x264-GROUP.mkv"
    end

    context "with no season number" do
      it_behaves_like "an unknown file", "Showname.E01.720p.HDTV.x264-GROUP.mkv"
    end

    context "with no episode number" do
      it_behaves_like "an unknown file", "Showname.S02.720p.HDTV.x264-GROUP.mkv"
    end

    context "with no tag" do
      it_behaves_like "an unknown file", "Showname.S02E01-GROUP.mkv"
    end

    context "with no group" do
      it_behaves_like "an unknown file", "Showname.S02E01.720p.HDTV.x264.mkv"
    end

    context "with no distribution" do
      it_behaves_like "a media file", "Showname.S02E01.720p.HDTV.x264-GROUP.mkv"
    end
  end

  describe "#basename" do
    subject { Addic7ed::VideoFile.new("/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP.mkv") }

    it "returns only file name given a full path" do
      expect(subject.basename).to eq "Showname.S02E01.720p.HDTV.x264-GROUP.mkv"
    end
  end

  describe "#to_s" do
    subject { Addic7ed::VideoFile.new("/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP.mkv") }

    it "returns file name as a string" do
      expect(subject.to_s).to eq "/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP.mkv"
    end
  end

  describe "#inspect" do
    let(:expected) do
      <<-EOS
        Guesses for Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv:
  show:         Showname
  season:       2
  episode:      1
  tags:         ["720P", "HDTV", "X264"]
  group:        GROUP
  distribution: DISTRIBUTION
EOS
    end

    subject { Addic7ed::VideoFile.new("Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv") }

    it "prints a human-readable detailed version" do
      expect(subject.inspect).to eq expected.strip
    end
  end
end
