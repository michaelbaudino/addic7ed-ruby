# addic7ed-ruby
[![Build Status](https://travis-ci.org/michaelbaudino/addic7ed-ruby.png)](https://travis-ci.org/michaelbaudino/addic7ed-ruby) [![Dependency Status](https://gemnasium.com/michaelbaudino/addic7ed-ruby.png)](https://gemnasium.com/michaelbaudino/addic7ed-ruby) [![Code Climate](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby.png)](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby) [![Coverage Status](https://coveralls.io/repos/michaelbaudino/addic7ed-ruby/badge.png?branch=master)](https://coveralls.io/r/michaelbaudino/addic7ed-ruby) [![Gem Version](https://badge.fury.io/rb/addic7ed.png)](http://badge.fury.io/rb/addic7ed)


Ruby command-line script to fetch subtitles on Addic7ed

Current version: **0.3.1**

### Is it working ?

Well, it should...

### How to use it ?

1. Install it:

    ```bash
    $ gem install addic7ed
    ```
2. Use it (e.g. to download a French subtitle for a "Californication" episode):

    ```bash
    $ addic7ed -l fr /path/to/Californication.S06E07.720p.HDTV.x264-2HD.mkv
    ```
3. Enjoy your show :tv:

### Are there any options ?

Sure

```bash
$ addic7ed -h
Usage: addic7ed [options] <file1> [<file2>, <file3>, ...]
    -l, --language [LANGUAGE]        Language code to look subtitles for (default: French)
    -a, --all-subtitles              Display all available subtitles
    -n, --do-not-download            Do not download the subtitle
    -f, --force                      Overwrite existing subtitle
    -v, --[no-]verbose               Run verbosely
    -q, --quiet                      Run without output (cron-mode)
    -d, --debug                      Debug mode [do not use]
    -h, --help                       Show this message
    -L, --list-languages             List all available languages
    -V, --version                    Show version number
```

### How to contribute ?

Feel free to submit a Pull Request, I'd be glad to review/merge it.

Also, if you like the awesome work done by the Addic7ed team, please consider [donating to them](http://www.addic7ed.com) !

### Notes

Addic7ed restricts the number of subtitle download to 15 per 24h (30 per 24h for registered users, and 55 for VIP users).

Don't get mad, they have to pay for their servers, you know.

### Roadmap

There's some work remaining:
- Support registered users
- Support directory parsing
- Support "hearing impaired" versions
- Document code
- Test cli behaviour
- Colorize output
- Write doc for cron usage
- Write doc for iwatch usage

### Changelog

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

### Supported Ruby versions

This projet supports the following Ruby versions/implementations:

* MRI 1.9.3
* MRI 2.0
* MRI 2.1
* Rubinius 2.2.5
* JRuby (both 1.9, 2.0 and 2.1 mode)

:warning: Rubinius users may have to manually install [RubySL](https://github.com/RubySL) before they can use `addic7ed-ruby`:

```shell
$ gem install rubysl
```

### License

This project is released under the terms of the MIT license.
See `LICENSE.md` file for details.
