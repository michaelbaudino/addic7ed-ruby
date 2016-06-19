require "spec_helper"

describe Addic7ed::GetShowsList do
  before { described_class.class_variable_set(:@@shows, nil) }

  it "downloads Addic7ed homepage" do
    subject.call
    expect(a_request(:get, "http://www.addic7ed.com")).to have_been_made
  end

  it "returns the list of shows names" do
    expect(described_class.call).to include "Game of Thrones", "The Walking Dead", "Californication", "Breaking Bad", "Weeds"
  end

  it "memoizes to minimize network requests" do
    2.times { subject.call }
    expect(a_request(:get, "http://www.addic7ed.com")).to have_been_made.once
  end
end
