require "spec_helper"
require "./lib/addic7ed"

describe Addic7ed::Subtitle, "#normalize_version!" do
  def normalized_version(version)
    Addic7ed::Subtitle.new(version: version).version
  end

  it "upcases everything" do
    expect(normalized_version("DiMENSiON")).to eq 'DIMENSION'
  end

  it "removes heading or trailing dots" do
    expect(normalized_version(".DIMENSION.")).to eq 'DIMENSION'
  end

  it "removes heading or trailing whitespaces" do
    expect(normalized_version(" DIMENSION ")).to eq 'DIMENSION'
  end

  it "removes heading or trailing dashes" do
    expect(normalized_version("-DIMENSION-")).to eq 'DIMENSION'
  end

  it "removes '720p' tag" do
    expect(normalized_version("720P DIMENSION")).to eq 'DIMENSION'
  end

  it "removes 'HDTV' tag" do
    expect(normalized_version("HDTV DIMENSION")).to eq 'DIMENSION'
  end

  it "removes 'x264' tag" do
    expect(normalized_version("X264 DIMENSION")).to eq 'DIMENSION'
    expect(normalized_version("X.264 DIMENSION")).to eq 'DIMENSION'
  end

  it "removes 'PROPER' tag" do
    expect(normalized_version("PROPER DIMENSION")).to eq 'DIMENSION'
  end

  it "removes 'RERIP' tag" do
    expect(normalized_version("RERIP DIMENSION")).to eq 'DIMENSION'
  end

  it "removes the 'Version' prefix" do
    expect(normalized_version("Version DIMENSION")).to eq 'DIMENSION'
  end
end

describe Addic7ed::Subtitle, "#to_s" do
  let(:subtitle) { Addic7ed::Subtitle.new(version: "DIMENSION", language: "fr", status: "Completed", url: "http://some.fancy.url", via: "http://addic7ed.com", downloads: "42") }

  it "prints a human readable version" do
    expect(subtitle.to_s).to eq "http://some.fancy.url\t->\tDIMENSION (fr, Completed) [42 downloads] (via http://addic7ed.com)"
  end
end

describe Addic7ed::Subtitle, "#works_for?" do
  let(:subtitle) { Addic7ed::Subtitle.new(version: "DIMENSION", comment: "Works with IMMERSE") }

  context "when it is incomplete" do
    before { allow(subtitle).to receive(:is_completed?).and_return(false) }

    it "returns false" do
      expect(subtitle.works_for? "DIMENSION").to be false
    end
  end

  context "when it is completed" do
    before { allow(subtitle).to receive(:is_completed?).and_return(true) }

    it "returns true given the exact same version" do
      expect(subtitle.works_for? "DIMENSION").to be true
    end

    it "returns true given a compatible version" do
      expect(subtitle.works_for? "LOL").to be true
    end

    it "returns false given an incompatible version" do
      expect(subtitle.works_for? "EVOLVE").to be false
    end

    it "returns true given the same version as comment" do
      expect(subtitle.works_for? "IMMERSE").to be true
    end

    it "returns true given a compatible version as comment" do
      expect(subtitle.works_for? "ASAP").to be true
    end

    it "returns false given an incompatible version as comment" do
      expect(subtitle.works_for? "KILLERS").to be false
    end
  end
end

describe Addic7ed::Subtitle, "#can_replace?" do
  let(:defaults)       { {version: "DIMENSION", language: "fr", status: "Completed", downloads: "10"} }
  let(:subtitle)       { Addic7ed::Subtitle.new(defaults) }
  let(:other_subtitle) { Addic7ed::Subtitle.new(defaults) }

  context "when it is incomplete" do
    before { allow(subtitle).to receive(:is_completed?).and_return(false) }

    it "returns false" do
      expect(subtitle.can_replace? other_subtitle).to be false
    end
  end

  context "when it is completed" do
    before { allow(subtitle).to receive(:is_completed?).and_return(true) }

    it "returns true given no other_subtitle" do
      expect(subtitle.can_replace? nil).to be true
    end

    context "when other_subtitle has a different language" do
      before { allow(other_subtitle).to receive(:language).and_return("en") }

      it "returns false" do
        expect(subtitle.can_replace? other_subtitle).to be false
      end
    end

    context "when other_subtitle has an incompatible version" do
      before { allow(subtitle).to receive(:is_compatible_with?).with(other_subtitle.version).and_return(false) }

      it "returns false" do
        expect(subtitle.can_replace? other_subtitle).to be false
      end
    end

    context "when other_subtitle is featured by Addic7ed" do
      before { allow(other_subtitle).to receive(:is_featured?).and_return(true) }

      it "returns false" do
        expect(subtitle.can_replace? other_subtitle).to be false
      end
    end

    context "when other_subtitle has more downloads" do
      before { allow(other_subtitle).to receive(:downloads).and_return(subtitle.downloads + 1) }

      it "returns false" do
        expect(subtitle.can_replace? other_subtitle).to be false
      end
    end

    context "when other_subtitle has less downloads" do
      before { allow(other_subtitle).to receive(:downloads).and_return(subtitle.downloads - 1) }

      it "returns true" do
        expect(subtitle.can_replace? other_subtitle).to be true
      end
    end
  end
end

describe Addic7ed::Subtitle, "#is_featured?" do
  it "returns true when 'via' is 'http://addic7ed.com'" do
    expect(Addic7ed::Subtitle.new(via: 'http://addic7ed.com').is_featured?).to be true
  end

  it "returns false otherwise" do
    expect(Addic7ed::Subtitle.new(via: 'anything else').is_featured?).to be false
  end
end

describe Addic7ed::Subtitle, "#is_completed?" do
  it "returns true when 'status' is 'Completed'" do
    expect(Addic7ed::Subtitle.new(status: 'Completed').is_completed?).to be true
  end

  it "returns false otherwise" do
    expect(Addic7ed::Subtitle.new(status: '80%').is_completed?).to be false
  end
end
