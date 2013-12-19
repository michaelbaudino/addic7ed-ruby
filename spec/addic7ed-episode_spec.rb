require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed::Episode do

  before :all do
    @filename = 'The Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.mkv'
    @filename_show_not_found = 'Show.Not.Found.S03E02.720p.HDTV.x264-EVOLVE.mkv'
    @filename_episode_not_found = 'The Walking.Dead.S03E42.720p.HDTV.x264-EVOLVE.mkv'
    @filename_compatible_group = 'The Walking.Dead.S03E04.HDTV.XviD-ASAP.mkv'
    @episode = Addic7ed::Episode.new(@filename)
  end

  it 'should create valid instance given valid argument' do
    expect{
      @episode = Addic7ed::Episode.new(@filename)
    }.to_not raise_error
  end

  describe '#url' do

    it 'should return a show localized URL given existing episode' do
      @episode.url('fr').should == 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8'
      @episode.url('es').should == 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/4'
    end

    it 'should use French as default language' do
      @episode.url.should == @episode.url('fr')
    end

    it 'should raise LanguageNotSupported given an unsupported language code' do
      expect{
        @episode.url('aa')
      }.to raise_error(Addic7ed::LanguageNotSupported)
    end

  end

  describe '#subtitles' do

    it 'should return an array of Addic7ed::Subtitle given valid episode and language' do
      ['fr', 'en', 'it'].each do |lang|
        lang_id = Addic7ed::LANGUAGES[lang][:id]
        stub_request(:get, "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/#{lang_id}")
          .to_return File.new("spec/responses/walking-dead-3-2-#{lang_id}.http")
      end
      @episode.subtitles('fr').size.should == 4
      @episode.subtitles('en').size.should == 3
      @episode.subtitles('it').size.should == 1
    end

    it 'should use French as default language' do
      @episode.subtitles.should == @episode.subtitles('fr')
    end

    it 'should raise LanguageNotSupported given an unsupported language code' do
      expect{
        @episode.subtitles('aa')
      }.to raise_error(Addic7ed::LanguageNotSupported)
    end

    it 'should raise EpisodeNotFound given not existing episode' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/42/8')
        .to_return File.new('spec/responses/walking-dead-3-42-8.http')
      expect{
        Addic7ed::Episode.new(@filename_episode_not_found).subtitles
      }.to raise_error(Addic7ed::EpisodeNotFound)
    end

    it 'should raise NoSubtitleFound given valid episode which has no subtitle on Addic7ed' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/48')
        .to_return File.new('spec/responses/walking-dead-3-2-48.http')
      expect{
        @episode.subtitles('az')
      }.to raise_error(Addic7ed::NoSubtitleFound)
    end

    it 'may raise a ParsingError, but I don\'t know how to test it :-('

    it 'may raise a WTFError, but it\'s unsure when, so it stays untested'

  end

  describe '#best_subtitle' do

    it 'should find the subtitle with status completed and same group name' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8')
        .to_return File.new('spec/responses/walking-dead-3-2-8.http')
      @episode.best_subtitle('fr').url.should == 'http://www.addic7ed.com/original/68018/4'
    end

    it 'should find the subtitle with status completed, compatible group name and as many downloads as possible' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/4/8')
        .to_return File.new('spec/responses/walking-dead-3-4-8.http')
      compatible_episode = Addic7ed::Episode.new(@filename_compatible_group)
      compatible_episode.best_subtitle('fr').url.should == 'http://www.addic7ed.com/updated/8/68508/3'
    end

    it 'should use French as default language' do
      @episode.best_subtitle.should == @episode.best_subtitle('fr')
    end

    it 'should raise LanguageNotSupported given an unsupported language code' do
      expect{
        @episode.best_subtitle('aa')
      }.to raise_error(Addic7ed::LanguageNotSupported)
    end

    it 'should raise NoSubtitleFound given valid episode which has no subtitle on Addic7ed' do
      stub_request(:get, 'http://www.addic7ed.com/serie/The_Walking_Dead/3/2/48')
        .to_return File.new('spec/responses/walking-dead-3-2-48.http')
      expect{
        @episode.best_subtitle('az')
      }.to raise_error(Addic7ed::NoSubtitleFound)
    end

  end

  describe '#download_best_subtitle!' do

    it 'should be tested, but I\'m not sure how to do it properly'

  end

end