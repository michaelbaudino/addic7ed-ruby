> ## :information_source: Upcoming Design Breaking Changes
>
> I'm [currently working on a full rewrite](https://github.com/michaelbaudino/addic7ed-ruby/pull/30) which will introduce some heavily breaking changes, including:
>
>  * a complete API refactor (almost a full rewrite) to enforce code quality, maintainability and single responsability principle
>  * documentation!
>  * the removal of any CLI feature (they will be moved to a separate `addic7ed-ruby-cli` gem)
>
> I'll publish some beta versions of the gem before merging the PR into `master` and releasing a final version (remember that the gem will no longer include a CLI tool). I'd love to receive some feedback about it, so feel free to [send me an email](mailto:michael.baudino@alpine-lab.com).

# addic7ed-ruby

[![Build Status](https://api.travis-ci.org/michaelbaudino/addic7ed-ruby.svg?branch=full-rewrite)](https://travis-ci.org/michaelbaudino/addic7ed-ruby)
[![Dependency Status](https://gemnasium.com/michaelbaudino/addic7ed-ruby.svg?travis)](https://gemnasium.com/michaelbaudino/addic7ed-ruby)
[![Code Climate](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby.svg)](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby)
[![Coverage Status](https://coveralls.io/repos/michaelbaudino/addic7ed-ruby/badge.svg?branch=master)](https://coveralls.io/r/michaelbaudino/addic7ed-ruby)
[![Gem Version](https://badge.fury.io/rb/addic7ed.svg)](http://badge.fury.io/rb/addic7ed)
[![security](https://hakiri.io/github/michaelbaudino/addic7ed-ruby/master.svg)](https://hakiri.io/github/michaelbaudino/addic7ed-ruby/master)
[![Inline docs](http://inch-ci.org/github/michaelbaudino/addic7ed-ruby.svg?branch=full-rewrite)](http://inch-ci.org/github/michaelbaudino/addic7ed-ruby?branch=full-rewrite)

Fetch TV shows subtitles on Addic7ed using Ruby.

### Refactoring TODO list

* [x] move download logic to a service object
* [x] add a new `Search` model
* [x] move compatibility logic to a `CheckCompatibility` service object
* [x] create a `SubtitlesCollection` class to hold and filter subtitles
* [x] move best subtitle logic to `SubtitlesCollection`
* [x] rename `Subtitle#via` to `Subtitle#source`
* [x] refactor how `Episode` holds `Subtitle`s
* [x] rename `ShowList` and make it a service object
* [x] write code documentation
* [x] Configure GitHub hook for [RubyDoc](http://www.rubydoc.info)
* [ ] move CLI to a separate gem (and use Thor or similar)
* [ ] update README to include only API stuff
* [x] add `bin/console`
* [x] remove `bin/addic7ed`
* [ ] move all `to_s` and `to_inspect` methods to the CLI
* [ ] refactor errors (to match Ruby errors hierarchy and maybe allow both bang-erroring and not-erroring versions of public API methods)
* [ ] refactor how HI works (allow both "no HI", "force HI" and "don't care")
* [x] use symbols rather than strings for languages
* [x] add Rubocop
* [x] move user agents and languages to a config file
* [ ] add specs for parsing
* [ ] Create a `Dockerfile` for the CLI

### Is it working ?

As long as Addic7ed HTML/CSS structure remains the same: yes :smile:

### How to use it ?

1. Install it:

    ```bash
    $ gem install addic7ed
    ```
2. Use it (e.g. to download a French subtitle for a "Californication" episode):

    ```bash
    $ addic7ed -l fr /path/to/Californication.S06E07.720p.HDTV.x264-2HD.mkv
    ```
3. A wild `Californication.S06E07.720p.HDTV.x264-2HD.fr.srt` file appears
4. Enjoy your show :tv:

### Are there any options ?

Sure !

```bash
$ addic7ed -h
Usage: addic7ed [options] <file1> [<file2>, <file3>, ...]
    -l, --language [LANGUAGE]        Language code to look subtitles for (default: French)
        --no-hi                      Only download subtitles without Hearing Impaired lines
    -a, --all-subtitles              Display all available subtitles
    -n, --do-not-download            Do not download the subtitle
    -f, --force                      Overwrite existing subtitle
    -u, --untagged                   Do not include language code in subtitle filename
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

### Contribution ideas

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

* Ruby 2.0 (MRI)
* Ruby 2.1 (MRI)
* Ruby 2.2 (MRI)
* Ruby 2.3 (MRI)
* Rubinius
* JRuby

:warning: Rubinius users may have to manually install [RubySL](https://github.com/RubySL) before they can use `addic7ed-ruby`:

```shell
$ gem install rubysl
```

### License

This project is released under the terms of the MIT license.
See `LICENSE.md` file for details.
