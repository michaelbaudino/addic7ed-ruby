# frozen_string_literal: true

require "spec_helper"

describe Addic7ed::DownloadSubtitle do
  let(:url)      { "http://www.addic7ed.com/original/68018/4" }
  let(:referer)  { "http://www.addic7ed.com/serie/The_Walking_Dead/3/2/8" }
  let(:filename) { "The.Walking.Dead.S03E02.720p.HDTV.x264-EVOLVE.fr.srt" }

  subject { described_class.new(url, filename, referer, 0) }

  describe "#call" do
    let!(:http_stub) do
      stub_request(:get, url)
        .to_return File.new("spec/responses/walking-dead-3-2-8_best_subtitle.http")
    end

    before { allow_any_instance_of(described_class).to receive(:write) }

    it "fetches the subtitle" do
      subject.call
      expect(http_stub).to have_been_requested
    end

    it "writes the subtitle to disk" do
      subject.call
      expect(subject).to have_received(:write)
    end

    context "when the HTTP request returns a HTTP redirection" do
      let!(:redirect_url)  { "http://www.addic7ed.com/original/68018/4.redirected" }
      let!(:http_stub) do
        stub_request(:get, url).to_return File.new("spec/responses/basic_redirection.http")
      end
      let!(:redirect_stub) do
        stub_request(:get, redirect_url)
          .to_return File.new("spec/responses/walking-dead-3-2-8_best_subtitle.http")
      end

      it "follows the redirection by calling itself with redirection URL" do
        subject.call
        expect(http_stub).to have_been_requested.once
        expect(redirect_stub).to have_been_requested.once
      end

      context "when it gets stuck in a redirection loop" do
        let!(:redirect_stub) do
          stub_request(:get, redirect_url)
            .to_return File.new("spec/responses/basic_redirection.http")
        end

        it "follows up to HTTP_REDIRECT_LIMIT redirections then raises a Addic7ed::DownloadError" do
          expect(described_class).to receive(:new).exactly(9).times.and_call_original
          expect { subject.call }.to raise_error Addic7ed::DownloadError
        end
      end
    end

    context "when a network error occurs" do
      let!(:http_stub) { stub_request(:get, url).to_timeout }

      it "raises Addic7ed::DownloadError" do
        expect { subject.call }.to raise_error Addic7ed::DownloadError
      end
    end
  end

  describe "#write(content)" do
    it "creates a new file on disk" do
      expect(Kernel).to receive(:open).with(filename, "w")
      subject.send(:write, "some content")
    end

    context "when an error occurs" do
      before { allow(Kernel).to receive(:open).and_raise(IOError) }

      it "raises a Addic7ed::DownloadError error" do
        expect { subject.send(:write, "some content") }.to raise_error Addic7ed::DownloadError
      end
    end
  end
end
