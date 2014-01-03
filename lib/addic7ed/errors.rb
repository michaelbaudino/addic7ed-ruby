module Addic7ed
  exceptions = [
    :InvalidFilename,       :ShowNotFound,    :EpisodeNotFound, :LanguageNotSupported,
    :ParsingError,          :NoSubtitleFound, :DownloadError,   :DownloadLimitReached,
    :SubtitleCannotBeSaved, :HTTPError
  ]

  exceptions.each { |e| const_set(e, Class.new(StandardError)) }
end
