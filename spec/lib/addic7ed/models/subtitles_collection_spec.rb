require "spec_helper"

describe Addic7ed::SubtitlesCollection do
  it "inherits from Array" do
    expect(described_class.superclass).to eq Array
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

  it "keeps completed subtitles" do
    expect(subject.completed).to include completed_subtitle
  end

  it "filters out incomplete subtitles" do
    expect(subject.completed).to_not include incomplete_subtitle
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
