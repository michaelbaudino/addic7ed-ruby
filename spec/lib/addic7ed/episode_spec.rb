require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed::Episode do
  before :all do
    @filename = 'The.Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.mkv'
    @filename_show_not_found = 'Show.Not.Found.S03E02.720p.HDTV.x264-EVOLVE.mkv'
    @filename_episode_not_found = 'The.Walking.Dead.S03E42.720p.HDTV.x264-EVOLVE.mkv'
    @filename_compatible_group = 'The.Walking.Dead.S03E04.HDTV.XviD-ASAP.mkv'
    @filename_no_hi = 'The.Walking.Dead.S03E02.720p.HDTV.x264-KILLERS.mkv'
    @episode = Addic7ed::Episode.new(@filename)
  end

  it 'should create valid instance given valid argument' do
    expect{ Addic7ed::Episode.new(@filename) }.to_not raise_error
  end

  describe '#url' do
    it 'returns a show localized URL given existing episode' do
      expect(@episode.url('fr')).to eq 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8'
      expect(@episode.url('es')).to eq 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/4'
    end

    it 'uses French as default language' do
      expect(@episode.url).to eq @episode.url('fr')
    end

    it 'raises LanguageNotSupported given an unsupported language code' do
      expect{ @episode.url('aa') }.to raise_error Addic7ed::LanguageNotSupported
    end
  end

  describe '#subtitles' do
    it 'should return an array of Addic7ed::Subtitle given valid episode and language' do
      %w{fr en it}.each do |lang|
        lang_id = Addic7ed::LANGUAGES[lang][:id]
        stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/#{lang_id}")
          .to_return File.new("spec/responses/walking-dead-3-2-#{lang_id}.http")
      end
      expect(@episode.subtitles('fr').size).to eq 4
      expect(@episode.subtitles('en').size).to eq 3
      expect(@episode.subtitles('it').size).to eq 1
    end

    it 'uses French as default language' do
      expect(@episode.subtitles).to eq @episode.subtitles('fr')
    end

    it 'raises LanguageNotSupported given an unsupported language code' do
      expect{ @episode.subtitles('aa') }.to raise_error Addic7ed::LanguageNotSupported
    end

    it 'raises EpisodeNotFound given not existing episode' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/42/8')
        .to_return File.new('spec/responses/walking-dead-3-42-8.http')
      expect{ Addic7ed::Episode.new(@filename_episode_not_found).subtitles }.to raise_error Addic7ed::EpisodeNotFound
    end

    it 'raises NoSubtitleFound given valid episode which has no subtitle on Addic7ed' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/48')
        .to_return File.new('spec/responses/walking-dead-3-2-48.http')
      expect{ @episode.subtitles('az') }.to raise_error Addic7ed::NoSubtitleFound
    end

    it 'may raise a ParsingError, but I\'m not sure how...'
  end

  describe '#best_subtitle' do
    it 'finds the subtitle with status completed and same group name' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8')
        .to_return File.new('spec/responses/walking-dead-3-2-8.http')
      expect(@episode.best_subtitle('fr').url).to eq 'http://www.addic7ed.com/original/68018/4'
    end

    it 'finds the subtitle with status completed, compatible group name and as many downloads as possible' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/4/8')
        .to_return File.new('spec/responses/walking-dead-3-4-8.http')
      compatible_episode = Addic7ed::Episode.new(@filename_compatible_group)
      expect(compatible_episode.best_subtitle('fr').url).to eq 'http://www.addic7ed.com/updated/8/68508/3'
    end

    it 'finds the subtitle with status completed, same group name and not hearing impaired' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/1')
        .to_return File.new('spec/responses/walking-dead-3-2-1.http')
      episode = Addic7ed::Episode.new(@filename_no_hi)
      expect(episode.best_subtitle('en', true).url).to eq 'http://www.addic7ed.com/updated/1/68018/0'
    end

    it 'uses French as default language' do
      expect(@episode.best_subtitle).to eq @episode.best_subtitle('fr')
    end

    it 'raises LanguageNotSupported given an unsupported language code' do
      expect{ @episode.best_subtitle('aa') }.to raise_error Addic7ed::LanguageNotSupported
    end

    it 'raises NoSubtitleFound given valid episode which has no subtitle on Addic7ed' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/48')
        .to_return File.new('spec/responses/walking-dead-3-2-48.http')
      expect{ @episode.best_subtitle('az') }.to raise_error Addic7ed::NoSubtitleFound
    end
  end

  describe '#download_best_subtitle!' do
    let(:videofilename) { "The.Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.mkv" }
    let(:lang)          { "fr" }
    let(:episode)       { Addic7ed::Episode.new(@filename) }
    let(:best_subtitle) { episode.best_subtitle(lang) }

    subject { episode.download_best_subtitle!(lang) }

    before { stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8").to_return File.new("spec/responses/walking-dead-3-2-8.http") }

    it "calls SubtitleDownloader on the best subtitle's URL" do
      expect(Addic7ed::SubtitleDownloader).to receive(:call).with(episode.best_subtitle("fr").url, anything(), anything())
      subject
    end

    it "calls SubtitleDownloader with episode's page as referer" do
      expect(Addic7ed::SubtitleDownloader).to receive(:call).with(anything(), anything(), episode.url)
      subject
    end

    it "calls SubtitleDownloader with videofile's filename with language-prefixed .srt extension" do
      expect(Addic7ed::SubtitleDownloader).to receive(:call).with(anything(), File.basename(videofilename, ".*") + ".#{lang}.srt", anything())
      subject
    end

    context "when untagged option is set" do
      let(:episode) { Addic7ed::Episode.new(@filename, true) }

      it "calls SubtitleDownloader with videofile's filename with .srt extension" do
        expect(Addic7ed::SubtitleDownloader).to receive(:call).with(anything(), File.basename(videofilename, ".*") + ".srt", anything())
        subject
      end
    end
  end
end
