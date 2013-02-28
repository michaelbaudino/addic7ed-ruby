require 'spec_helper'
require './lib/addic7ed-errors'
require './lib/addic7ed-episode'
require './lib/addic7ed-subtitle'

describe Addic7ed::Episode do
  before :all do
    @filename = 'Californication.S06E07.720p.HDTV.x264-2HD.mkv'
    @filename_show_not_found = 'Show.Not.Found.S06E07.720p.HDTV.x264-2HD.mkv'
    @filename_episode_not_found = 'Californication.S06E42.720p.HDTV.x264-2HD.mkv'
  end

  it 'should create valid instance given valid argument' do
    expect{
      @episode = Addic7ed::Episode.new(@filename)
    }.to_not raise_error
  end

  describe '#show_id' do
    it 'should return a show ID given existing show' do
      @episode = Addic7ed::Episode.new(@filename)
      @episode.show_id.should == '109'
    end
    it 'should raise ShowNotFound given not existing show' do
      @episode = Addic7ed::Episode.new(@filename_show_not_found)
      expect {@episode.show_id}.to raise_error(Addic7ed::ShowNotFound)
    end
  end

  describe '#global_url' do
    it 'should return a show URL given existing episode' do
      @episode = Addic7ed::Episode.new(@filename)
      @episode.global_url.should == 'http://www.addic7ed.com/serie/Californication/6/7/The_Dope_Show'
    end
    it 'should raise EpisodeNotFound given existing show not existing episode' do
      @episode = Addic7ed::Episode.new(@filename_episode_not_found)
      expect {@episode.global_url}.to raise_error(Addic7ed::EpisodeNotFound)
    end
  end

  describe '#localized_url' do
    before :all do
      @episode = Addic7ed::Episode.new(@filename)
    end
    it 'should return a show localized URL given existing episode' do
      @episode.localized_url('fr').should == 'http://www.addic7ed.com/serie/Californication/6/7/8'
      @episode.localized_url('es').should == 'http://www.addic7ed.com/serie/Californication/6/7/4'
    end
    it 'should use French as default language' do
      @episode.localized_url.should == @episode.localized_url('fr')
    end
    it 'should raise LanguageNotSupported given an unsupported language code' do
      expect{
        @episode.localized_url('aa')
      }.to raise_error(Addic7ed::LanguageNotSupported)
    end
  end

  describe '#subtitles' do
    before :all do
      @filename = 'The.Walking.Dead.S03E02.720p.HDTV.x264-IMMERSE.mkv'
      @episode = Addic7ed::Episode.new(@filename)
    end
    it 'should return an array of Addic7ed::Subtitle given valid episode and language' do
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
      expect{
        Addic7ed::Episode.new(@filename_episode_not_found).subtitles
      }.to raise_error(Addic7ed::EpisodeNotFound)
    end
    it 'should raise NoSubtitleFound given valid episode which has no subtitle on Addic7ed' do
      expect{
        @episode.subtitles('es')
      }.to raise_error(Addic7ed::NoSubtitleFound)
    end
    it 'may raise a ParsingError, but I don\'t know how to test it :-('
    it 'may raise a WTFError, but it\'s unsure when, so it stays untested'
  end

end