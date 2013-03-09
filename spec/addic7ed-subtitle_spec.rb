require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed::Subtitle do
  before :all do
  end

  it 'should upcase the version string' do
    Addic7ed::Subtitle.new('DiMENSiON', '', '', '', '0').version.should == 'DIMENSION'
  end

  it 'should automatically remove "720p" in version string' do
    Addic7ed::Subtitle.new('720p DIMENSION', '', '', '', '0').version.should == 'DIMENSION'
    Addic7ed::Subtitle.new('720P DIMENSION', '', '', '', '0').version.should == 'DIMENSION'
    Addic7ed::Subtitle.new('DIMENSION 720p', '', '', '', '0').version.should == 'DIMENSION'
    Addic7ed::Subtitle.new('DIMENSION 720P', '', '', '', '0').version.should == 'DIMENSION'
  end
end