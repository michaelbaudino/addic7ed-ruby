module Addic7ed
  class InvalidFilename < StandardError; end
  class ShowNotFound < StandardError; end
  class EpisodeNotFound < StandardError; end
  class LanguageNotSupported < StandardError; end
  class ParsingError < StandardError; end
  class NoSubtitleFound < StandardError; end
  class DownloadError < StandardError; end
  class DownloadLimitReached < StandardError; end
  class SubtitleCannotBeSaved < StandardError; end
  class HTTPError < StandardError; end
end
