# frozen_string_literal: true

require "spec_helper"

describe Addic7ed::NormalizeComment do
  def normalized_comment(comment)
    described_class.call(comment)
  end

  it "downcases everything" do
    expect(normalized_comment("DiMENSiON")).to eq "dimension"
  end

  it "removes extra heading and trailing whitespaces" do
    expect(normalized_comment(" \t AVS\t\r\n ")).to eq "avs"
  end
end
