# frozen_string_literal: true

require "spec_helper"

describe Addic7ed::Episode do
  let(:showname)    { "The.Walking.Dead" }
  let(:season)      { 3 }
  let(:episode_nbr) { 2 }
  let(:episode)     { described_class.new(show: showname, season: season, number: episode_nbr) }


  describe "#page_url(lang)" do
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

    context "when given an unsupported language code" do
      it "raises LanguageNotSupported" do
        expect { episode.page_url(:aa) }.to raise_error Addic7ed::LanguageNotSupported
      end
    end

    context "when not given a language code" do
      it "returns the URL of the page with subtitles from all languages" do
        expect(episode.page_url).to eq "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/0"
      end
    end
  end

  describe "#subtitles" do
    xit "should be tested"
  end
end
