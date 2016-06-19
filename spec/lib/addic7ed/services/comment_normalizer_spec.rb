require "spec_helper"
require "./lib/addic7ed"

describe Addic7ed::CommentNormalizer do
  def normalized_comment(comment)
    described_class.call(comment)
  end

  it "downcases everything" do
    expect(normalized_comment("DiMENSiON")).to eq "dimension"
  end
end
