require "spec_helper"
require "./lib/addic7ed"

describe Addic7ed::Episode, "#localized_urls" do
  let(:filename) { "The.Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.mkv" }
  let(:episode)  { described_class.new(filename) }

  subject { episode.send(:localized_urls) }

  it "returns a hash of episode page localized URL" do
    expect(subject["fr"]).to eq "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8"
    expect(subject["es"]).to eq "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/4"
  end

  it "raises LanguageNotSupported given an unsupported language code" do
    expect{ subject["aa"] }.to raise_error Addic7ed::LanguageNotSupported
  end
end

describe Addic7ed::Episode, "#subtitles" do
  let(:filename) { "The.Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.mkv" }
  let(:episode) { described_class.new(filename) }

  before do
    %w{fr en it}.each do |lang|
      lang_id = Addic7ed::LANGUAGES[lang][:id]
      stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/#{lang_id}")
        .to_return File.new("spec/responses/walking-dead-3-2-#{lang_id}.http")
    end
  end

  it "should return an array of Addic7ed::Subtitle given valid episode and language" do
    expect(episode.subtitles("fr").size).to eq 4
    expect(episode.subtitles("en").size).to eq 3
    expect(episode.subtitles("it").size).to eq 1
  end

  it "uses English as default language" do
    expect(episode.subtitles).to eq episode.subtitles("en")
  end

  it "raises LanguageNotSupported given an unsupported language code" do
    expect{ episode.subtitles("aa") }.to raise_error Addic7ed::LanguageNotSupported
  end

  it "memoizes results to minimize network requests" do
    2.times { episode.subtitles }
    expect(a_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/1")).to have_been_made.times(1)
  end

  context "when episode does not exist" do
    let(:filename) { "The.Walking.Dead.S03E42.720p.HDTV.x264-EVOLVE.mkv" }

    before { stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/42/8").to_return File.new("spec/responses/walking-dead-3-42-8.http") }

    it "raises EpisodeNotFound given not existing episode" do
      expect{ described_class.new(filename).subtitles("fr") }.to raise_error Addic7ed::EpisodeNotFound
    end
  end

  context "when episode exists but has no subtitles" do
    before { stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/48").to_return File.new("spec/responses/walking-dead-3-2-48.http") }

    it "raises NoSubtitleFound given valid episode which has no subtitle on Addic7ed" do
      expect{ episode.subtitles("az") }.to raise_error Addic7ed::NoSubtitleFound
    end
  end
end

###
### THE FOLLOWING WILL BE MOVED TO A NEW SERVICE OBJECT AND REWRITTEN
###

# describe Addic7ed::Episode, "#best_subtitle" do
#   let(:lang)                      { "fr" }
#   let(:filename)                  { "The.Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.mkv" }
#   let(:filename_no_hi)            { "The.Walking.Dead.S03E02.720p.HDTV.x264-KILLERS.mkv" }
#   let(:filename_compatible_group) { "The.Walking.Dead.S03E04.HDTV.XviD-ASAP.mkv" }
#   let(:episode)                   { Addic7ed::Episode.new(filename) }

#   it "finds the subtitle with status completed and same group name" do
#     stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8")
#       .to_return File.new("spec/responses/walking-dead-3-2-8.http")
#     expect(episode.best_subtitle("fr").url).to eq "http://www.addic7ed.com/original/68018/4"
#   end

#   it "finds the subtitle with status completed, compatible group name and as many downloads as possible" do
#     stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/4/8")
#       .to_return File.new("spec/responses/walking-dead-3-4-8.http")
#     compatible_episode = Addic7ed::Episode.new(filename_compatible_group)
#     expect(compatible_episode.best_subtitle("fr").url).to eq "http://www.addic7ed.com/updated/8/68508/3"
#   end

#   it "finds the subtitle with status completed, same group name and not hearing impaired" do
#     stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/1")
#       .to_return File.new("spec/responses/walking-dead-3-2-1.http")
#     episode = Addic7ed::Episode.new(filename_no_hi)
#     expect(episode.best_subtitle("en", true).url).to eq "http://www.addic7ed.com/updated/1/68018/0"
#   end

#   it "uses English as default language" do
#     expect(episode.best_subtitle).to eq episode.best_subtitle("en")
#   end

#   it "raises LanguageNotSupported given an unsupported language code" do
#     expect{ episode.best_subtitle("aa") }.to raise_error Addic7ed::LanguageNotSupported
#   end

#   it "raises NoSubtitleFound given valid episode which has no subtitle on Addic7ed" do
#     stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/48")
#       .to_return File.new("spec/responses/walking-dead-3-2-48.http")
#     expect{ episode.best_subtitle("az") }.to raise_error Addic7ed::NoSubtitleFound
#   end
# end

describe Addic7ed::Episode, "#download_best_subtitle!" do
  let(:filename)      { "The.Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.mkv" }
  let(:lang)          { "fr" }
  let(:episode)       { described_class.new(filename) }
  let(:best_subtitle) { double(:best_subtitle, url: "http://best.subtitle.url") }

  subject { episode.download_best_subtitle!(lang) }

  before { allow(episode).to receive(:best_subtitle).and_return(best_subtitle) }

  it "calls DownloadSubtitle on the best subtitle's URL" do
    expect(Addic7ed::DownloadSubtitle).to receive(:call).with(best_subtitle.url, anything(), anything())
    subject
  end

  it "calls DownloadSubtitle with episode's page as referer" do
    expect(Addic7ed::DownloadSubtitle).to receive(:call).with(anything(), anything(), episode.send(:localized_urls)[lang])
    subject
  end

  it "calls DownloadSubtitle with videofile's filename with language-prefixed .srt extension" do
    expect(Addic7ed::DownloadSubtitle).to receive(:call).with(anything(), File.basename(filename, ".*") + ".#{lang}.srt", anything())
    subject
  end

  context "when untagged option is set" do
    let(:episode) { described_class.new(filename, true) }

    it "calls DownloadSubtitle with videofile's filename with .srt extension" do
      expect(Addic7ed::DownloadSubtitle).to receive(:call).with(anything(), File.basename(filename, ".*") + ".srt", anything())
      subject
    end
  end
end
