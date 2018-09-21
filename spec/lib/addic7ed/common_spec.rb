# frozen_string_literal: true

require "spec_helper"

describe Addic7ed do
  it "defines LANGUAGES" do
    expect(Addic7ed::LANGUAGES).to_not be_nil
    expect(Addic7ed::LANGUAGES).to include fr: { name: "French", id: 8 }
  end

  it "defines USER_AGENTS" do
    expect(Addic7ed::USER_AGENTS).to_not be_nil
  end
end
