# frozen_string_literal: true

require "spec_helper"

describe Addic7ed::GetShowsList do
  before { Singleton.__init__(described_class) }

  it "downloads Addic7ed homepage" do
    described_class.call
    expect(a_request(:get, "http://www.addic7ed.com")).to have_been_made
  end

  it "returns the list of shows names" do
    some_shows = ["Game of Thrones", "The Walking Dead", "Californication", "Breaking Bad", "Weeds"]
    expect(described_class.call).to include(*some_shows)
  end

  it "memoizes to minimize network requests" do
    2.times { described_class.call }
    expect(a_request(:get, "http://www.addic7ed.com")).to have_been_made.once
  end
end
