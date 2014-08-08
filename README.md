# addic7ed-ruby
[![Build Status](https://travis-ci.org/michaelbaudino/addic7ed-ruby.svg)](https://travis-ci.org/michaelbaudino/addic7ed-ruby) [![Code Climate](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby/badges/gpa.svg)](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby) [![Test Coverage](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby/badges/coverage.svg)](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby) [![Gem Version](https://badge.fury.io/rb/addic7ed.svg)](http://badge.fury.io/rb/addic7ed) [![Dependency Status](https://gemnasium.com/michaelbaudino/addic7ed-ruby.svg)](https://gemnasium.com/michaelbaudino/addic7ed-ruby)


Ruby command-line script to fetch subtitles on Addic7ed

Current version: **0.3.2**

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

Sure !

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

Ho, and by the way, please, **please**: do not hammer their servers, play fair !

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
