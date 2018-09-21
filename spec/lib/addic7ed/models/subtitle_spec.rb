# frozen_string_literal: true

require "spec_helper"

describe Addic7ed::Subtitle, "#initialize" do
  let(:version) { "Version DIMENSiON" }
  let(:comment) { "Works for LOL" }

  subject { described_class.new(version: version, comment: comment) }

  it "normalizes Addic7ed version" do
    expect(Addic7ed::NormalizeVersion).to receive(:call).with(version)
    subject
  end

  it "normalizes Addic7ed comment" do
    expect(Addic7ed::NormalizeComment).to receive(:call).with(comment)
    subject
  end
end

describe Addic7ed::Subtitle, "#completed?" do
  it "returns true when 'status' is 'Completed'" do
    expect(Addic7ed::Subtitle.new(status: "Completed").completed?).to be true
  end

  it "returns false otherwise" do
    expect(Addic7ed::Subtitle.new(status: "80%").completed?).to be false
  end
end
