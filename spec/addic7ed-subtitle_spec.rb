require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed::Subtitle do
  before :all do
  end

  describe '#normalized_version' do
    it 'should upcase the version string' do
      Addic7ed::Subtitle.new('DiMENSiON', '', '', '', '', '0').version.should == 'DIMENSION'
    end

    it 'should remove heading and trailing dots' do
      Addic7ed::Subtitle.new('.DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION.', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('.DIMENSION.', '', '', '', '', '0').version.should == 'DIMENSION'
    end

    it 'should remove heading and trailing whitespaces' do
      Addic7ed::Subtitle.new(' DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION ', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new(' DIMENSION ', '', '', '', '', '0').version.should == 'DIMENSION'
    end

    it 'should remove heading and trailing dashes' do
      Addic7ed::Subtitle.new('-DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION-', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('-DIMENSION-', '', '', '', '', '0').version.should == 'DIMENSION'
    end

    it 'should automatically remove "720p" in version string' do
      Addic7ed::Subtitle.new('720p DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('720P DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION 720p', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION 720P', '', '', '', '', '0').version.should == 'DIMENSION'
    end

    it 'should automatically remove "HDTV" in version string' do
      Addic7ed::Subtitle.new('hdtv DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('HDTV DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION hdtv', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION HDTV', '', '', '', '', '0').version.should == 'DIMENSION'
    end

    it 'should automatically remove "x264" in version string' do
      Addic7ed::Subtitle.new('x264 DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('X264 DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('x.264 DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('X.264 DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION x264', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION X264', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION x.264', '', '', '', '', '0').version.should == 'DIMENSION'
      Addic7ed::Subtitle.new('DIMENSION X.264', '', '', '', '', '0').version.should == 'DIMENSION'
    end
  end
end
