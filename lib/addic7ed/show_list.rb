module Addic7ed
  class ShowList
    def self.find(raw_name)
      raw_name.
        gsub('.', ' ').
        gsub(/ /, '_').
        gsub(/_(US)$/i, '_(\1)').
        gsub(/_(US)_/i, '_(\1)_').
        gsub(/_UK$/i, '').
        gsub(/_UK_/i, '_').
        gsub(/_\d{4}$/, '').
        gsub(/_\d{4}_/, '_')
    end
  end
end
