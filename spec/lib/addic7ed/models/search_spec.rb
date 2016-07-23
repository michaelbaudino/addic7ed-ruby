require "spec_helper"

describe Addic7ed::Search do
  let(:video_filename) { "Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv" }
  let(:language)       { "fr" }
  let(:options)        { {} }
  let(:subtitles_fr)   { [] }
  let(:episode)        { double(:episode) }
  let(:video_file) do
    double(:video_file, showname: "Game.of.Thrones", season: 6, episode: 9, group: "AVS")
  end

  before do
    allow(Addic7ed::VideoFile).to receive(:new).and_return(video_file)
    allow(Addic7ed::Episode).to receive(:new).and_return(episode)
    allow(episode).to receive(:subtitles).with(language).and_return(subtitles_fr)
  end

  subject { described_class.new(video_filename, language, options) }

  describe "#video_file" do
    it "returns the associated Addic7ed::VideoFile" do
      subject.video_file
      expect(Addic7ed::VideoFile).to have_received(:new).with(video_filename)
    end

    it "is memoized" do
      2.times { subject.video_file }
      expect(Addic7ed::VideoFile).to have_received(:new).exactly(1)
    end
  end

  describe "#episode" do
    it "returns the associated Addic7ed::Episode object" do
      subject.episode
      expect(Addic7ed::Episode).to have_received(:new).with("Game.of.Thrones", 6, 9)
    end
  end
end
