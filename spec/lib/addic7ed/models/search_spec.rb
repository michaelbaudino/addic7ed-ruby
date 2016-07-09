require "spec_helper"

describe Addic7ed::Search do
  let(:video_filename) { "Game.of.Thrones.S06E09.720p.HDTV.x264-AVS.mkv" }
  let(:language)       { "fr" }
  let(:options)        { {} }

  let(:subtitles_fr)   { [] }

  let(:video_file)     { double(:video_file, showname: "Game.of.Thrones", season: 6, episode: 9, group: "AVS") }
  let(:episode)        { double(:episode) }

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

  ####
  #### THE FOLLOWING WILL BE MOVED TO A NEW SERVICE OBJECT AND REWRITTEN
  ####
  # describe "#best_subtitle" do
  #   let(:video_filename)                  { "The.Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.mkv" }
  #   let(:video_filename_no_hi)            { "The.Walking.Dead.S03E02.720p.HDTV.x264-KILLERS.mkv" }
  #   let(:video_filename_compatible_group) { "The.Walking.Dead.S03E04.HDTV.XviD-ASAP.mkv" }
  #   let(:episode)                         { Addic7ed::Episode.new(video_filename, language, options) }
  #
  #   it "finds the subtitle with status completed and same group name" do
  #     stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8")
  #       .to_return File.new("spec/responses/walking-dead-3-2-8.http")
  #     expect(episode.best_subtitle("fr").url).to eq "http://www.addic7ed.com/original/68018/4"
  #   end
  #
  #   it "finds the subtitle with status completed, compatible group name and as many downloads as possible" do
  #     stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/4/8")
  #       .to_return File.new("spec/responses/walking-dead-3-4-8.http")
  #     compatible_episode = Addic7ed::Episode.new(filename_compatible_group)
  #     expect(compatible_episode.best_subtitle("fr").url).to eq "http://www.addic7ed.com/updated/8/68508/3"
  #   end
  #
  #   it "finds the subtitle with status completed, same group name and not hearing impaired" do
  #     stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/1")
  #       .to_return File.new("spec/responses/walking-dead-3-2-1.http")
  #     episode = Addic7ed::Episode.new(filename_no_hi)
  #     expect(episode.best_subtitle("en", true).url).to eq "http://www.addic7ed.com/updated/1/68018/0"
  #   end
  #
  #   it "uses English as default language" do
  #     expect(episode.best_subtitle).to eq episode.best_subtitle("en")
  #   end
  #
  #   it "raises LanguageNotSupported given an unsupported language code" do
  #     expect{ episode.best_subtitle("aa") }.to raise_error Addic7ed::LanguageNotSupported
  #   end
  #
  #   it "raises NoSubtitleFound given valid episode which has no subtitle on Addic7ed" do
  #     stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/48")
  #       .to_return File.new("spec/responses/walking-dead-3-2-48.http")
  #     expect{ episode.best_subtitle("az") }.to raise_error Addic7ed::NoSubtitleFound
  #   end
  # end
end
