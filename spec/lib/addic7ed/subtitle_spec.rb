require 'spec_helper'
require './lib/addic7ed'

describe Addic7ed::Subtitle do
  describe '#normalized_version' do
    it 'upcases the version string' do
      expect(Addic7ed::Subtitle.new('DiMENSiON', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'removes heading and trailing dots' do
      expect(Addic7ed::Subtitle.new('.DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION.', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('.DIMENSION.', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'removes heading and trailing whitespaces' do
      expect(Addic7ed::Subtitle.new(' DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION ', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new(' DIMENSION ', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'removes heading and trailing dashes' do
      expect(Addic7ed::Subtitle.new('-DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION-', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('-DIMENSION-', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'automatically removes "720p" in version string' do
      expect(Addic7ed::Subtitle.new('720p DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('720P DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION 720p', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION 720P', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'automatically removes "HDTV" in version string' do
      expect(Addic7ed::Subtitle.new('hdtv DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('HDTV DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION hdtv', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION HDTV', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'automatically removes "x264" in version string' do
      expect(Addic7ed::Subtitle.new('x264 DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('X264 DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('x.264 DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('X.264 DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION x264', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION X264', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION x.264', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION X.264', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'automatically removes "PROPER" in version string' do
      expect(Addic7ed::Subtitle.new('PROPER DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('Proper DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION PROPER', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION Proper', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'automatically removes "RERIP" in version string' do
      expect(Addic7ed::Subtitle.new('RERIP DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('Rerip DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION RERIP', '', '', '', '', '0').version).to eq 'DIMENSION'
      expect(Addic7ed::Subtitle.new('DIMENSION Rerip', '', '', '', '', '0').version).to eq 'DIMENSION'
    end

    it 'automatically removes "Version" prefix in version string' do
      expect(Addic7ed::Subtitle.new('Version DIMENSION', '', '', '', '', '0').version).to eq 'DIMENSION'
    end
  end

  describe '#to_s' do
    it 'prints a human readable version' do
      sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', 'http://some.fancy.url', 'http://addic7ed.com', '42')
      expect(sub.to_s).to eq "http://some.fancy.url\t->\tDIMENSION (fr, Completed) [42 downloads] (via http://addic7ed.com)"
    end
  end

  describe '#works_for?' do
    context 'when incomplete' do
      before(:all) { @sub = Addic7ed::Subtitle.new('', '', '80%', '', '', '10') }

      it 'returns false' do
        expect(@sub.works_for?).to be false
      end
    end

    context 'when completed' do
      before(:all) { @sub = Addic7ed::Subtitle.new('DIMENSION', '', 'Completed', '', '', '10') }

      it 'returns true given the exact same version' do
        expect(@sub.works_for? 'DIMENSION').to be true
      end

      it 'returns true given a compatible version' do
        expect(@sub.works_for? 'LOL').to be true
      end

      it 'returns true when the subtitle is for a PROPER version' do
        sub = Addic7ed::Subtitle.new('PROPER DIMENSION', '', 'Completed', '', '', '10')
        expect(sub.works_for? 'DIMENSION').to be true
        expect(sub.works_for? 'LOL').to be true
      end

      it 'returns false given an incompatible version' do
        expect(@sub.works_for? 'EVOLVE').to be false
      end
    end
  end

  describe '#can_replace?' do
    context 'when incomplete' do
      it 'returns false' do
        sub = Addic7ed::Subtitle.new('', '', '80%', '', '', '10')
        any_other_sub = Addic7ed::Subtitle.new('', '', '', '', '', '0')
        expect(sub.can_replace? any_other_sub).to be false
      end
    end

    context 'when completed' do
      before(:all) { @sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', '', '', '10') }

      it 'returns true given no other_sub' do
        expect(@sub.can_replace? nil).to be true
      end

      it 'returns false given other_sub for another language' do
        other_sub = Addic7ed::Subtitle.new('DIMENSION', 'en', 'Completed', '', '', '10')
        expect(@sub.can_replace? other_sub).to be false
      end

      it 'returns false given other_sub for incompatible version' do
        other_sub = Addic7ed::Subtitle.new('EVOLVE', 'fr', 'Completed', '', '', '10')
        expect(@sub.can_replace? other_sub).to be false
      end

      context 'given other_sub language & version compatible' do
        it 'returns false given other_sub featured by Addic7ed' do
          other_sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', '', 'http://addic7ed.com', '10')
          expect(@sub.can_replace? other_sub).to be false
        end

        it 'returns false given other_sub with more downloads' do
          other_sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', '', '', '20')
          expect(@sub.can_replace? other_sub).to be false
        end

        it 'returns true given other_sub with less downloads' do
          other_sub = Addic7ed::Subtitle.new('DIMENSION', 'fr', 'Completed', '', '', '5')
          expect(@sub.can_replace? other_sub).to be true
        end
      end
    end
  end
end
