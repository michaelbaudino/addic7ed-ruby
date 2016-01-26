require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed::VideoFile do
  let(:file) { Addic7ed::VideoFile.new(filename) }

  shared_examples "a media file" do |filename, expected_show_name|
    let(:filename) { filename }

    it "it detects successfully" do
      expect(file.showname    ).to eq (expected_show_name || 'Showname')
      expect(file.season      ).to eq 2
      expect(file.episode     ).to eq 1
      expect(file.tags        ).to eq ['720P', 'HDTV', 'X264']
      expect(file.group       ).to eq 'GROUP'
      expect(file.distribution).to satisfy { |d| ['', 'DISTRIBUTION'].include?(d) }
    end
  end

  shared_examples "an unknown file" do |filename|
    let(:filename) { filename }

    it "raises an error" do
      expect{file}.to raise_error Addic7ed::InvalidFilename
    end
  end

  describe "#initialize" do
    context "with regular notation" do
      it_behaves_like "a media file", "Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "with x notation" do
      it_behaves_like "a media file", "Showname.02x01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context 'with 3-digits notation' do
      it_behaves_like "a media file", "Showname.201.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context 'with brackets notation' do
      it_behaves_like "a media file", "Showname.[S02E01].720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context 'with brackets and x notation' do
      it_behaves_like "a media file", "Showname.[2x01].720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context 'with brackets and 3-digits notation' do
      it_behaves_like "a media file", "Showname.[201].720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context 'with brackets and x notation and space separator' do
      it_behaves_like "a media file", "Showname [2x01] 720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context 'with brackets and 3-digits notation and space separator' do
      it_behaves_like "a media file", "Showname [201] 720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context 'with lowercase filename' do
      it_behaves_like "a media file", "showname.s02e01.720p.HDTV.x264-group[distribution].mkv", "showname"
    end

    context 'with multiple words in show name' do
      it_behaves_like "a media file", "Show.Name.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv", "Show Name"
    end

    context 'with multiple words in show name separated by spaces' do
      it_behaves_like "a media file", "Show Name.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv", "Show Name"
    end

    context 'with only numbers in show name' do
      it_behaves_like "a media file", "42.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv", "42"
    end

    context "with production year" do
      it_behaves_like "a media file", "Showname.2014.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv", "Showname 2014"
    end

    context "with a full path" do
      it_behaves_like "a media file", "/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "with a relative path" do
      it_behaves_like "a media file", "../path/to/Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "without extension" do
      it_behaves_like "a media file", "Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION]"
    end

    context "with a double episode" do
      it_behaves_like "a media file", "Showname.S02E0102.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "with a double episode" do
      it_behaves_like "a media file", "Showname.S02E01E02.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "with a double episode with dash separator" do
      it_behaves_like "a media file", "Showname.S02E01-02.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "with no showname" do
      it_behaves_like "an unknown file", ".S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "with no season number" do
      it_behaves_like "an unknown file", "Showname.E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "with no episode number" do
      it_behaves_like "an unknown file", "Showname.S02.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end

    context "with no tag" do
      it_behaves_like "an unknown file", "Showname.S02E01-GROUP[DISTRIBUTION].mkv"
    end

    context "with no group" do
      it_behaves_like "an unknown file", "Showname.S02E01.720p.HDTV.x264[DISTRIBUTION].mkv"
    end

    context "with no distribution" do
      it_behaves_like "a media file", "Showname.S02E01.720p.HDTV.x264-GROUP.mkv"
    end

  end

  describe '#encoded_filename' do
    it 'changes all spaces to underscores' do
      expect(Addic7ed::VideoFile.new("Show Name.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'Show_Name'
    end

    it 'wraps country code with parenthesis' do
      expect(Addic7ed::VideoFile.new("Showname.US.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'Showname_(US)'
    end

    it 'detects country code even in lowercase' do
      expect(Addic7ed::VideoFile.new("showname.us.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'showname_(us)'
    end

    it "removes country code for the original show when it's UK" do
      expect(Addic7ed::VideoFile.new("Showname.UK.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'Showname'
    end

    it 'removes production year' do
      expect(Addic7ed::VideoFile.new("Showname.2014.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'Showname'
    end

    it 'handles when both country code and production year are present' do
      expect(Addic7ed::VideoFile.new("Showname.2014.UK.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'Showname'
      expect(Addic7ed::VideoFile.new("Showname.UK.2014.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'Showname'
      expect(Addic7ed::VideoFile.new("Showname.2014.US.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'Showname_(US)'
      expect(Addic7ed::VideoFile.new("Showname.US.2014.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").encoded_showname).to eq 'Showname_(US)'
    end
  end

  describe '#basename' do
    it 'returns only file name given a full path' do
      expect(Addic7ed::VideoFile.new("/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").basename).to eq "Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end
  end

  describe '#dirname' do
    it 'returns only path given a full path' do
      expect(Addic7ed::VideoFile.new("/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").dirname).to eq '/full/path/to'
    end
  end

  describe '#extname' do
    it 'returns only file extension given a full path' do
      expect(Addic7ed::VideoFile.new("/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").extname).to eq '.mkv'
    end
  end

  describe '#to_s' do
    it 'returns file name as a string' do
      expect(Addic7ed::VideoFile.new("/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").to_s).to eq "/full/path/to/Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv"
    end
  end

  describe '#inspect' do
    it 'prints a human-readable detailed version' do
      expect(Addic7ed::VideoFile.new("Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv").inspect).to eq(
'Guesses for Showname.S02E01.720p.HDTV.x264-GROUP[DISTRIBUTION].mkv:
  show:         Showname
  season:       2
  episode:      1
  tags:         ["720P", "HDTV", "X264"]
  group:        GROUP
  distribution: DISTRIBUTION')
    end
  end
end
