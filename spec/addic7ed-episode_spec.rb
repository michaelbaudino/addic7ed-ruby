require 'spec_helper'
require 'open-uri'
Bundler.require
require './lib/addic7ed-errors'
require './lib/addic7ed-episode'

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
    it 'should raise an error given not existing show' do
      @episode = Addic7ed::Episode.new(@filename_show_not_found)
      expect {@episode.show_id}.to raise_error(Addic7ed::ShowNotFoundError)
    end
  end

  describe '#global_url' do
    it 'should return a show URL given existing episode' do
      @episode = Addic7ed::Episode.new(@filename)
      @episode.global_url.should == 'http://www.addic7ed.com/serie/Californication/6/7/The_Dope_Show'
    end
    it 'should raise an error given existing show not existing episode' do
      @episode = Addic7ed::Episode.new(@filename_episode_not_found)
      expect {@episode.global_url}.to raise_error(Addic7ed::EpisodeNotFoundError)
    end
  end

  describe '#localized_url' do
    it 'should return a show localized URL given existing episode' do
      @episode = Addic7ed::Episode.new(@filename)
      @episode.localized_url('fr').should == 'http://www.addic7ed.com/serie/Californication/6/7/8'
      @episode.localized_url('es').should == 'http://www.addic7ed.com/serie/Californication/6/7/4'
    end
    it 'should use French as default language' do
      @episode = Addic7ed::Episode.new(@filename)
      @episode.localized_url.should == @episode.localized_url('fr')
    end
    it 'should raise an error given existing show not existing episode' do
      @episode = Addic7ed::Episode.new(@filename_episode_not_found)
      expect {@episode.localized_url}.to raise_error(Addic7ed::EpisodeNotFoundError)
    end

  end
end