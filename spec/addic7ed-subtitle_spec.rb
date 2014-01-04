require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed::Subtitle do

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

    it 'should automatically remove "Version" prefix in version string' do
      Addic7ed::Subtitle.new('Version DIMENSION', '', '', '', '', '0').version.should == 'DIMENSION'
    end

  end

  describe '#to_s' do

    it 'should print a human readable version' do
      sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', 'http://some.fancy.url', 'http://addic7ed.com', '42')
      expect(sub.to_s).to eql("http://some.fancy.url\t->\tDIMENSION (fr, Completed) [42 downloads] (via http://addic7ed.com)")
    end

  end

  describe '#works_for?' do

    context 'when incomplete' do

      before :all do
        @sub = Addic7ed::Subtitle.new('', '', '80%', '', '', '10')
      end

      it 'should return false' do
        expect(@sub.works_for?).to be false
      end

    end

    context 'when completed' do

      before :all do
        @sub = Addic7ed::Subtitle.new('DIMENSION', '', 'Completed', '', '', '10')
      end

      it 'should return true given the exact same version' do
        expect(@sub.works_for? 'DIMENSION').to be true
      end

      it 'should return true given a compatible version' do
        expect(@sub.works_for? 'LOL').to be true
      end

      it 'should return false given an incompatible version' do
        expect(@sub.works_for? 'EVOLVE').to be false
      end

    end

  end


  describe '#can_replace?' do

    context 'when incomplete' do

      it 'should return false' do
        sub = Addic7ed::Subtitle.new('', '', '80%', '', '', '10')
        any_other_sub = Addic7ed::Subtitle.new('', '', '', '', '', '0')
        expect(sub.can_replace? any_other_sub).to be false
      end

    end

    context 'when completed' do

      before :all do
        @sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', '', '', '10')
      end

      it 'should return true given no other_sub' do
        expect(@sub.can_replace? nil).to be true
      end

      it 'should return false given other_sub for another language' do
        other_sub = Addic7ed::Subtitle.new('DIMENSION', 'en', 'Completed', '', '', '10')
        expect(@sub.can_replace? other_sub).to be false
      end

      it 'should return false given other_sub for incompatible version' do
        other_sub = Addic7ed::Subtitle.new('EVOLVE', 'fr', 'Completed', '', '', '10')
        expect(@sub.can_replace? other_sub).to be false
      end

      context 'given other_sub language & version compatible' do

        it 'should return false given other_sub featured by Addic7ed' do
          other_sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', '', 'http://addic7ed.com', '10')
          expect(@sub.can_replace? other_sub).to be false
        end

        it 'should return false given other_sub with more downloads' do
          other_sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', '', '', '20')
          expect(@sub.can_replace? other_sub).to be false
        end

        it 'should return true given other_sub with less downloads' do
          other_sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', '', '', '5')
          expect(@sub.can_replace? other_sub).to be true
        end

      end

    end

  end

end