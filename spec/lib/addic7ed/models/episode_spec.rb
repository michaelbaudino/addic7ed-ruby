require "spec_helper"

describe Addic7ed::Episode, "#subtitles" do
  let(:showname)    { "The.Walking.Dead" }
  let(:season)      { 3 }
  let(:episode_nbr) { 2 }
  let(:episode)     { described_class.new(showname, season, episode_nbr) }

  before do
    [:fr, :en, :it].each do |lang|
      lang_id = Addic7ed::LANGUAGES[lang][:id]
      stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/#{lang_id}")
        .to_return File.new("spec/responses/walking-dead-3-2-#{lang_id}.http")
    end
  end

  it "returns an array of Addic7ed::Subtitle given valid episode and language" do
    expect(episode.subtitles(:fr).size).to eq 4
    expect(episode.subtitles(:en).size).to eq 3
    expect(episode.subtitles(:it).size).to eq 1
  end

  it "raises LanguageNotSupported given an unsupported language code" do
    expect { episode.subtitles(:aa) }.to raise_error Addic7ed::LanguageNotSupported
  end

  it "memoizes results to minimize network requests" do
    2.times { episode.subtitles(:en) }
    expect(
      a_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/1")
    ).to have_been_made.times(1)
  end

  context "when episode does not exist" do
    let(:episode_nbr) { 42 }

    before do
      stub_request(
        :get,
        "http://www.addic7ed.com/serie/The_Walking_Dead/3/42/8"
      ).to_return File.new("spec/responses/walking-dead-3-42-8.http")
    end

    it "raises EpisodeNotFound" do
      expect do
        described_class.new(showname, season, episode_nbr).subtitles(:fr)
      end.to raise_error Addic7ed::EpisodeNotFound
    end
  end

  context "when episode exists but has no subtitles" do
    before do
      stub_request(
        :get,
        "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/48"
      ).to_return File.new("spec/responses/walking-dead-3-2-48.http")
    end

    it "raises NoSubtitleFound" do
      expect { episode.subtitles(:az) }.to raise_error Addic7ed::NoSubtitleFound
    end
  end
end

describe Addic7ed::Episode, "#page_url(lang)" do
  let(:showname)    { "The.Walking.Dead" }
  let(:season)      { 3 }
  let(:episode_nbr) { 2 }
  let(:episode)     { described_class.new(showname, season, episode_nbr) }

  it "returns an episode page URL for given language" do
    expect(episode.page_url(:fr)).to eq "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8"
    expect(episode.page_url(:es)).to eq "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/4"
  end

  it "uses URLEncodeShowName to generate the localized URLs" do
    expect(
      Addic7ed::URLEncodeShowName
    ).to receive(:call).with(showname).and_return("The_Walking_Dead")
    episode.page_url(:fr)
  end

  it "raises LanguageNotSupported given an unsupported language code" do
    expect { episode.page_url(:aa) }.to raise_error Addic7ed::LanguageNotSupported
  end
end
