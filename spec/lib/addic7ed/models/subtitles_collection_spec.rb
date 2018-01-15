# frozen_string_literal: true

require "spec_helper"

describe Addic7ed::SubtitlesCollection do
  it "is an Enumerable" do
    expect(subject).to be_a Enumerable
  end
end

describe Addic7ed::SubtitlesCollection, "#compatible_with(group)" do
  let(:compatible_subtitle)   { double(:compatible_subtitle) }
  let(:incompatible_subtitle) { double(:incompatible_subtitle) }

  before do
    allow(Addic7ed::CheckCompatibility).to receive(:call) do |subtitle, _|
      case subtitle
      when compatible_subtitle   then true
      when incompatible_subtitle then false
      end
    end
  end

  subject { described_class.new([compatible_subtitle, incompatible_subtitle]) }

  it "is chainable" do
    expect(subject.compatible_with("group")).to be_a described_class
  end

  it "uses Addic7ed::CheckCompatibility" do
    subject.compatible_with("group")
    expect(Addic7ed::CheckCompatibility).to have_received(:call).twice
  end

  it "keeps compatible subtitles" do
    expect(subject.compatible_with("group")).to include compatible_subtitle
  end

  it "filers out incompatible subtitles" do
    expect(subject.compatible_with("group")).to_not include incompatible_subtitle
  end
end

describe Addic7ed::SubtitlesCollection, "#completed" do
  let(:completed_subtitle)  { double(:completed_subtitle, completed?: true) }
  let(:incomplete_subtitle) { double(:incomplete_subtitle, completed?: false) }

  subject { described_class.new([completed_subtitle, incomplete_subtitle]) }

  it "is chainable" do
    expect(subject.completed).to be_a described_class
  end

  it "keeps completed subtitles" do
    expect(subject.completed).to include completed_subtitle
  end

  it "filters out incomplete subtitles" do
    expect(subject.completed).to_not include incomplete_subtitle
  end
end

describe Addic7ed::SubtitlesCollection, "#for_language(language)" do
  let(:english_subtitle) { double(:english_subtitle, language: "English") }
  let(:french_subtitle)  { double(:french_subtitle, language: "French") }
  let(:spanish_subtitle) { double(:spanish_subtitle, language: "Spanish") }
  let(:all_subtitles)    { [english_subtitle, french_subtitle, spanish_subtitle] }

  subject { described_class.new(all_subtitles).for_language(:en) }

  it "is chainable" do
    expect(subject).to be_a described_class
  end

  it "keeps requested language subtitles" do
    expect(subject).to include english_subtitle
  end

  it "filters out other languages subtitles" do
    expect(subject).to_not include french_subtitle
    expect(subject).to_not include spanish_subtitle
  end
end

describe Addic7ed::SubtitlesCollection, "#most_popular" do
  let(:popular_subtitle)   { double(:popular_subtitle, downloads: 100) }
  let(:unpopular_subtitle) { double(:popular_subtitle, downloads: 20) }

  subject { described_class.new([popular_subtitle, unpopular_subtitle]) }

  it "returns the subtitle with the most downloads" do
    expect(subject.most_popular).to eq popular_subtitle
  end
end
