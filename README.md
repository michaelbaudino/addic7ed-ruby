# addic7ed-ruby [![Build Status](https://travis-ci.org/michaelbaudino/addic7ed-ruby.png)](https://travis-ci.org/michaelbaudino/addic7ed-ruby) [![Dependency Status](https://gemnasium.com/michaelbaudino/addic7ed-ruby.png)](https://gemnasium.com/michaelbaudino/addic7ed-ruby)

Ruby command-line script to fetch subtitles on Addic7ed

Current version: **0.1.0**

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

Also, if you like the awesome work done by the Addic7ed team, please consider [donating to them](http://www.chipin.com/contribute/id/780aa4c5d8c51efd).

### Notes

Addic7ed restricts the number of subtitle download to 15 per 24h (30 per 24h for registered users, and 55 for VIP users).

Don't get mad, they have to pay for their servers, you know.

### Roadmap

There's some work remaining:
- Support registered users
- Support directory parsing
- Document code
- Test cli behaviour
- Colorize output
- Write doc for cron usage
- Write doc for iwatch usage

### Changelog

* 0.1.0: This is now a gem
* 0.0.1: Added ability to actually download a subtitle
* 0.0.6: Added choice of the best subtitle to download, amongst all available for an episode
* 0.0.5: Added support for Travis-CI
* 0.0.4: Added retrieving of Addic7ed URL for an episode (including URL for a specific language)
* 0.0.3: Added parsing of command line arguments
* 0.0.2: Added Filename class to analyze filenames and guess showname, season and episode number
* 0.0.1: Initial file structure (Bundler, Rspec, Readme, ...)

### License (MIT)

Copyright (c) 2013 Michael Baudino

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.