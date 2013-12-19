require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed::Filename do

  before :all do
    # Valid filenames
    @filename = 'Californication.S06E07.720p.HDTV.x264-2HD.mkv'
    @filename_x = 'Californication.06x07.720p.HDTV.x264-2HD.mkv'
    @filename_3digits = 'Californication.607.720p.HDTV.x264-2HD.mkv'
    @filename_brackets = 'Californication.[S06E07].720p.HDTV.x264-2HD.mkv'
    @filename_x_brackets = 'Californication.[6x07].720p.HDTV.x264-2HD.mkv'
    @filename_3digits_brackets = 'Californication.[607].720p.HDTV.x264-2HD.mkv'
    @filename_brackets_spaces = 'Californication [607] 720p.HDTV.x264-2HD.mkv'
    @filename_x_brackets_spaces = 'Californication [6x07] 720p.HDTV.x264-2HD.mkv'
    @filename_3digits_brackets_spaces = 'Californication [607] 720p.HDTV.x264-2HD.mkv'
    @filename_lowercase = 'californication.s06e07.720p.hdtv.x264-2hd.mkv'
    @filename_lowercase_x = 'californication.6x07.720p.hdtv.x264-2hd.mkv'
    @filename_multiple_words = 'The.Walking.Dead.S03E11.720p.HDTV.x264-EVOLVE.mkv'
    @filename_multiple_words_spaces = 'The Walking Dead S03E11 720p.HDTV.x264-EVOLVE.mkv'
    @filename_numbers_only = '90210.S05E12.720p.HDTV.X264-DIMENSION.mkv'
    @filename_showname_year = 'The.Americans.2013.S01E04.720p.HDTV.X264-DIMENSION.mkv'
    @filename_full_path = '/data/public/Series/Californication/Saison 06/Californication.S06E07.720p.HDTV.x264-2HD.mkv'
    @filename_relative_path = '../Saison 06/Californication.S06E07.720p.HDTV.x264-2HD.mkv'
    @filename_no_extension = 'Californication.S06E07.720p.HDTV.x264-2HD'
    # Invalid filenames
    @filename_no_showname = '.S06E07.720p.HDTV.x264-2HD.mkv'
    @filename_no_season = 'Californication.E07.720p.HDTV.x264-2HD.mkv'
    @filename_no_episode = 'Californication.S06.720p.HDTV.x264-2HD.mkv'
    @filename_no_tags = 'Californication.S06E07.2HD.mkv'
    @filename_no_group = 'Californication.S06E07.720p.HDTV.x264.mkv'
    # Filename with special tags
    @filename_showname_US = 'Shameless.US.S03E06.720p.HDTV.x264-IMMERSE.mkv'
    @filename_showname_UK = 'Shameless.UK.S09E11.720p.HDTV.x264-TLA.mkv'
    @filename_showname_UK_year = 'The.Hour.UK.2011.S01E03.REPACK.HDTV.XviD-FoV.avi'
    @filename_showname_year_UK = 'The.Hour.2011.UK.S01E03.REPACK.HDTV.XviD-FoV.avi'
    @filename_showname_US_year = 'The.Hour.US.2011.S01E03.REPACK.HDTV.XviD-FoV.avi'
    @filename_showname_year_US = 'The.Hour.2011.US.S01E03.REPACK.HDTV.XviD-FoV.avi'
  end

  it 'should succeed given valid argument' do
    expect {
      @file = Addic7ed::Filename.new(@filename)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with x notation' do
    expect {
      @file = Addic7ed::Filename.new(@filename_x)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with 3-digits notation' do
    expect {
      @file = Addic7ed::Filename.new(@filename_3digits)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with brackets notation' do
    expect {
      @file = Addic7ed::Filename.new(@filename_brackets)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with brackets and x notation' do
    expect {
      @file = Addic7ed::Filename.new(@filename_x_brackets)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with brackets and 3-digits notation' do
    expect {
      @file = Addic7ed::Filename.new(@filename_3digits_brackets)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with brackets notation and space separator' do
    expect {
      @file = Addic7ed::Filename.new(@filename_brackets_spaces)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with brackets and x notation and space separator' do
    expect {
      @file = Addic7ed::Filename.new(@filename_x_brackets_spaces)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with brackets and 3-digits notation and space separator' do
    expect {
      @file = Addic7ed::Filename.new(@filename_3digits_brackets_spaces)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given lowercase filename' do
    expect {
      @file = Addic7ed::Filename.new(@filename_lowercase)
    }.to_not raise_error
    @file.showname.should == 'californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given lowercase filename with x notation' do
    expect {
      @file = Addic7ed::Filename.new(@filename_lowercase_x)
    }.to_not raise_error
    @file.showname.should == 'californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename with showname containing multiple words' do
    expect {
      @file = Addic7ed::Filename.new(@filename_multiple_words)
    }.to_not raise_error
    @file.showname.should == 'The Walking Dead'
    @file.season.should == 3
    @file.episode.should == 11
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == 'EVOLVE'
  end

  it 'should succeed given filename with showname containing multiple words with space separator' do
    expect {
      @file = Addic7ed::Filename.new(@filename_multiple_words_spaces)
    }.to_not raise_error
    @file.showname.should == 'The Walking Dead'
    @file.season.should == 3
    @file.episode.should == 11
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == 'EVOLVE'
  end

  it 'should succeed given filename with showname containing only numbers' do
    expect {
      @file = Addic7ed::Filename.new(@filename_numbers_only)
    }.to_not raise_error
    @file.showname.should == '90210'
    @file.season.should == 5
    @file.episode.should == 12
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == 'DIMENSION'
  end

  it 'should succeed given filename with showname containing production year' do
    expect {
      @file = Addic7ed::Filename.new(@filename_showname_year)
    }.to_not raise_error
    @file.showname.should == 'The Americans 2013'
    @file.season.should == 1
    @file.episode.should == 4
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == 'DIMENSION'
  end

  it 'should succeed given filename containing full path' do
    expect {
      @file = Addic7ed::Filename.new(@filename_full_path)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename containing relative path' do
    expect {
      @file = Addic7ed::Filename.new(@filename_relative_path)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should succeed given filename containing no extension' do
    expect {
      @file = Addic7ed::Filename.new(@filename_no_extension)
    }.to_not raise_error
    @file.showname.should == 'Californication'
    @file.season.should == 6
    @file.episode.should == 7
    @file.tags.should == ['720P', 'HDTV', 'X264']
    @file.group.should == '2HD'
  end

  it 'should fail given filename with no showname' do
    expect {
      @file = Addic7ed::Filename.new(@filename_no_showname)
    }.to raise_error
  end

  it 'should fail given filename with no season number' do
    expect {
      @file = Addic7ed::Filename.new(@filename_no_season)
    }.to raise_error
  end

  it 'should raise InvalidFilename given filename with no episode number' do
    expect {
      @file = Addic7ed::Filename.new(@filename_no_episode)
    }.to raise_error(Addic7ed::InvalidFilename)
  end

  it 'should raise InvalidFilename given filename with no tags' do
    expect {
      @file = Addic7ed::Filename.new(@filename_no_tags)
    }.to raise_error(Addic7ed::InvalidFilename)
  end

  it 'should raise InvalidFilename given filename with no group' do
    expect {
      @file = Addic7ed::Filename.new(@filename_no_group)
    }.to raise_error(Addic7ed::InvalidFilename)
  end

  describe '#encoded_filename' do

    it 'should change all spaces to underscores' do
      Addic7ed::Filename.new(@filename_multiple_words).encoded_showname.should == 'The_Walking_Dead'
    end

    it 'should wrap country code with parenthesis' do
      Addic7ed::Filename.new(@filename_showname_US).encoded_showname.should == 'Shameless_(US)'
    end

    it 'should remove country code for the original show (usually UK)' do
      Addic7ed::Filename.new(@filename_showname_UK).encoded_showname.should == 'Shameless'
    end

    it 'should remove production year' do
      Addic7ed::Filename.new(@filename_showname_year).encoded_showname.should == 'The_Americans'
    end

    it 'should handle when both country code and production year are present' do
      Addic7ed::Filename.new(@filename_showname_UK_year).encoded_showname.should == 'The_Hour'
      Addic7ed::Filename.new(@filename_showname_year_UK).encoded_showname.should == 'The_Hour'
      Addic7ed::Filename.new(@filename_showname_US_year).encoded_showname.should == 'The_Hour_(US)'
      Addic7ed::Filename.new(@filename_showname_year_US).encoded_showname.should == 'The_Hour_(US)'
    end

  end

  describe '#basename' do

    it 'should return only file name given a full path' do
      Addic7ed::Filename.new(@filename_full_path).basename.should == 'Californication.S06E07.720p.HDTV.x264-2HD.mkv'
    end

  end

  describe '#dirname' do

    it 'should return only path given a full path' do
      Addic7ed::Filename.new(@filename_full_path).dirname.should == '/data/public/Series/Californication/Saison 06'
    end

  end

  describe '#extname' do

    it 'should return only file extension given a full path' do
      Addic7ed::Filename.new(@filename_full_path).extname.should == '.mkv'
    end

  end

  describe '#to_s' do

    it 'should return file name as a string' do
      Addic7ed::Filename.new(@filename_full_path).to_s.should == '/data/public/Series/Californication/Saison 06/Californication.S06E07.720p.HDTV.x264-2HD.mkv'
    end

  end

end
