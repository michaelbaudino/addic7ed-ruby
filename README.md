# addic7ed-ruby

[![Build Status](https://api.travis-ci.org/michaelbaudino/addic7ed-ruby.svg?branch=full-rewrite)](https://travis-ci.org/michaelbaudino/addic7ed-ruby)
[![Dependency Status](https://gemnasium.com/michaelbaudino/addic7ed-ruby.svg?travis)](https://gemnasium.com/michaelbaudino/addic7ed-ruby)
[![Code Climate](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby.svg)](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby)
[![Coverage Status](https://coveralls.io/repos/michaelbaudino/addic7ed-ruby/badge.svg?branch=master)](https://coveralls.io/r/michaelbaudino/addic7ed-ruby)
[![Gem Version](https://badge.fury.io/rb/addic7ed.svg)](http://badge.fury.io/rb/addic7ed)
[![security](https://hakiri.io/github/michaelbaudino/addic7ed-ruby/master.svg)](https://hakiri.io/github/michaelbaudino/addic7ed-ruby/master)
[![Inline docs](http://inch-ci.org/github/michaelbaudino/addic7ed-ruby.svg?branch=full-rewrite)](http://inch-ci.org/github/michaelbaudino/addic7ed-ruby?branch=full-rewrite)

A Ruby API for [Addic7ed](http://www.addic7ed.com), the best TV subtitles community in the world.

> :information_source: This is a Ruby wrapper only: if you're looking for the CLI tool, please see [addic7ed-cli](michaelbaudino/addic7ed-cli).

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem "addic7ed"
```

Then execute:

```shell
$ bundle
```

## Usage

> :books: Check out the [API reference](http://www.rubydoc.info/github/michaelbaudino/addic7ed-ruby) for full documentation :books:

### `Addic7ed::Episode`

An `Episode` object represents an episode with a show name, season number and episode number:

```ruby
episode = Addic7ed::Episode.new(show: "Game of Thrones", season: 6, number: 9)
#=> #<Addic7ed::Episode @number=9, @season=6, @show="Game of Thrones">
```

It provides a `subtitles` instance method that returns all available subtitles for this episode:

```ruby
episode.subtitles
#=> #<Addic7ed::SubtitlesCollection
#     @subtitles=[
#       #<Addic7ed::Subtitle ... >,
#       #<Addic7ed::Subtitle ... >,
#       #<Addic7ed::Subtitle ... >
#     ]
```

It also provides a `page_url` instance method that returns the URL of the page listing all subtitles (or all those for a given `language`, if passed as argument) on Addic7ed:

```ruby
episode.page_url       #=> "http://www.addic7ed.com/serie/Game_of_Thrones/6/9/0"
episode.page_url(:fr)  #=> "http://www.addic7ed.com/serie/Game_of_Thrones/6/9/8"
```

> :information_source: This is used internally to list available subtitles (see `subtitles` method above) but is also useful when later downloading a subtitle file because it can be used as a referrer (which is a required HTTP header to download subtitle files).

> :boom: It raises `Addic7ed::LanguageNotSupported` if an unknown language code is passed to `page_url`.

### `Addic7ed::SubtitlesCollection`

A `SubtitlesCollection` is an enumerable class that provides several filtering methods:

* `compatible_with(group)` which returns only subtitles compatible with the given `group` releases
* `completed` which returns only completed subtitles
* `for_language(language)` which returns only subtitles in the given `language`
* `most_popular` which returns the most downloaded subtitle

Those methods are chainable, which lets you, for example:

* select subtitles completed and compatible with a given release group:

    ```ruby
    good_subtitles = episode.subtitles.completed.compatible_with("KILLERS")
    ```

* find the most popular subtitle among those:

    ```ruby
    best_subtitle = good_subtitles.most_popular
    ```

> :boom: It raises `LanguageNotSupported` when `for_language` is called with an unknown/unsupported language code.

> :bulb: A `SubtitlesCollection` instance can be filtered using any method from `Enumerable` (including your well-known friends `each`, `map`, `select`, `reject`, `find`, `group_by`, `any?`, `count`, `inject`, `sort`, `reduce`, ...).

### `Addic7ed::Subtitle`

A `Subtitle` object represents a subtitle file available on Addic7ed. It has several attributes:

```ruby
subtitle = Addic7ed::Subtitle.new(
  version:   "Version KILLERS, 720p AVS, 0.00 MBs",
  language:  "French",
  status:    "Completed",
  source:    "http://sous-titres.eu",
  downloads: 10335,
  comment:   "works with 1080p.BATV",
  corrected: true,
  hi:        false,
  url:       "http://www.addic7ed.com/original/113643/4"
)

subtitle.version      #=> "Version KILLERS, 720p AVS, 0.00 MBs"
subtitle.language     #=> "French"
subtitle.status       #=> "Completed"
subtitle.source       #=> "http://sous-titres.eu"
subtitle.downloads    #=> 10335
subtitle.comment      #=> "works with 1080p.BATV"
subtitle.corrected    #=> true
subtitle.hi           #=> false
subtitle.url          #=> "http://www.addic7ed.com/original/113643/4"
```

It also has a special `completed?` instance method that returns a boolean (`true` if `status` is `"Completed"`, `false` otherwise):

```ruby
subtitle.completed?   #=> true
```

### `Addic7ed::VideoFile`

The `VideoFile` class lets you extract and guess relevant information from a video file name, then provides them as instance methods:

```ruby
video = Addic7ed::VideoFile.new("~/Downloads/Game.of.Thrones.S06E09.720p.HDTV.x264-AVS[eztv].mkv")

video.showname      #=> "Game.Of.Thrones"
video.season        #=> 6
video.episode       #=> 9
video.tags          #=> ["720P", "HDTV", "X264"]
video.group         #=> "AVS"
video.distribution  #=> "EZTV"
video.basename      #=> "Game.of.Thrones.S06E09.720p.HDTV.x264-AVS[eztv].mkv"
```

> :boom: It raises `InvalidFilename` when it fails to infer any information from the file name :cry:

## Notes

Addic7ed restricts the number of subtitles downloads to 15 per 24h (30 per 24h for registered users, and 55 for VIP users). Don't get mad, they have to pay for their servers, you know. Ho, and by the way, please, **please**: do not hammer their servers, play fair!

## Contribute

Feel free to submit a [pull request](michaelbaudino/addic7ed-ruby/pulls), I'd be glad to review/merge it.

Also, if you like the awesome work done by the Addic7ed team, please consider [donating to them](http://www.addic7ed.com) :moneybag:

### Supported Ruby versions

This project [supports](https://github.com/michaelbaudino/addic7ed-ruby/blob/full-rewrite/.travis.yml) the following Ruby versions/implementations:

* Ruby 2.0 (MRI)
* Ruby 2.1 (MRI)
* Ruby 2.2 (MRI)
* Ruby 2.3 (MRI)
* Ruby 2.4 (MRI)
* Ruby 2.5 (MRI)
* Rubinius
* JRuby

:warning: Rubinius users may have to manually install [RubySL](https://github.com/RubySL) before they can use `addic7ed-ruby`:

```shell
$ gem install rubysl
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/michaelbaudino/addic7ed-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct (see `CODE_OF_CONDUCT.md` file).

## License

This gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT) (see `LICENSE.md` file).
