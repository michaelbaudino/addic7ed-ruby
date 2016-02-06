## Changelog

* 1.0.0: Drop support for Ruby 1.9 and add support for Ruby 2.3
* 0.7.0: Add support for incompatibility comments ('Doesn't work', 'Resync from', ...)
* 0.6.0: Consider 1080p version from same group as compatible version
* 0.5.1: Fix a bug in error handling because of bad copypasta from former method rename :spaghetti:
* 0.5.0: Add compatibility check from the comment field (thanks to @Pmaene)
* 0.4.0: Append language code when saving subtitles files (can be disabled with `-u|--untagged`)
* 0.3.4: Support RERIP in file names
* 0.3.3: Add detecion of video filenames with double episode number (e.g. `s02e22-23`)
* 0.3.3: Support double episodes
* 0.3.2: Support lowercase country codes in filenames
* 0.3.1: Fix a bug in subtitle version string normalization
* 0.3.0: Add support for PROPER versions of subtitles (thanks to @thibaudgg)
* 0.2.0: Add Rubinius support (also, quite a large code refactoring)
* 0.1.9: Fix the scraper because of a modification on Addic7ed website
* 0.1.8: Added priority to subtitles uploaded by Addic7ed staff
* 0.1.7: Fixed a bug when a subtitle had multiple revisions on Addic7ed.com
* 0.1.6: Enhanced subtitles version string filters (remove heading and trailing dashes)
* 0.1.5: Enhanced subtitles version string filters (remove heading and trailing spaces and dots)
* 0.1.4: Fixed a bug in require paths which made 0.1.3 unusable
* 0.1.3: Fixed bugs with show names containing country code or production year
* 0.1.2: Fixed how the daily download limit reach is detected
* 0.1.1: This is now a _working_ gem
* 0.1.0: This is now a gem
* 0.0.1: Added ability to actually download a subtitle
* 0.0.6: Added choice of the best subtitle to download, amongst all available for an episode
* 0.0.5: Added support for Travis-CI
* 0.0.4: Added retrieving of Addic7ed URL for an episode (including URL for a specific language)
* 0.0.3: Added parsing of command line arguments
* 0.0.2: Added Filename class to analyze filenames and guess showname, season and episode number
* 0.0.1: Initial file structure (Bundler, Rspec, Readme, ...)
