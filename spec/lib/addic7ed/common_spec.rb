require "spec_helper"

describe Addic7ed do
  it "defines SHOWS_URL" do
    expect(Addic7ed::SHOWS_URL).to_not be_nil
  end

  it "defines EPISODES_URL" do
    expect(Addic7ed::EPISODES_URL).to_not be_nil
  end

  it "defines EPISODE_REDIRECT_URL" do
    expect(Addic7ed::EPISODE_REDIRECT_URL).to_not be_nil
  end

  it "defines LANGUAGES" do
    expect(Addic7ed::LANGUAGES).to_not be_nil
    expect(Addic7ed::LANGUAGES).to include "fr" => { name: "French", id: 8 }
  end
end
