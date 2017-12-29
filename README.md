# addic7ed-ruby

[![Build Status](https://api.travis-ci.org/michaelbaudino/addic7ed-ruby.svg?branch=full-rewrite)](https://travis-ci.org/michaelbaudino/addic7ed-ruby)
[![Dependency Status](https://gemnasium.com/michaelbaudino/addic7ed-ruby.svg?travis)](https://gemnasium.com/michaelbaudino/addic7ed-ruby)
[![Code Climate](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby.svg)](https://codeclimate.com/github/michaelbaudino/addic7ed-ruby)
[![Coverage Status](https://coveralls.io/repos/michaelbaudino/addic7ed-ruby/badge.svg?branch=master)](https://coveralls.io/r/michaelbaudino/addic7ed-ruby)
[![Gem Version](https://badge.fury.io/rb/addic7ed.svg)](http://badge.fury.io/rb/addic7ed)
[![security](https://hakiri.io/github/michaelbaudino/addic7ed-ruby/master.svg)](https://hakiri.io/github/michaelbaudino/addic7ed-ruby/master)
[![Inline docs](http://inch-ci.org/github/michaelbaudino/addic7ed-ruby.svg?branch=full-rewrite)](http://inch-ci.org/github/michaelbaudino/addic7ed-ruby?branch=full-rewrite)

A Ruby API for [Addic7ed](http://www.addic7ed.com), the best TV subtitles community in the world.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem "addic7ed"
```

Then execute:

```shell
$ bundle
```

## Usage examples

> :books: Check out the [API reference](http://www.rubydoc.info/github/michaelbaudino/addic7ed-ruby) for full documentation :books:

### `Addic7ed::Episode`

An `Episode` object represents an episode with a show name, season number and episode number:

```ruby
episode = Addic7ed::Episode.new(show: "Game of Thrones", season: 6, number: 9)
#=> #<Addic7ed::Episode @number=9, @season=6, @show="Game of Thrones">
```

It provides a `subtitles` method that returns all available subtitles for this episode:

```ruby
episode.subtitles
#=> #<Addic7ed::SubtitlesCollection
#     @subtitles=[
#       #<Addic7ed::Subtitle ... >,
#       #<Addic7ed::Subtitle ... >,
#       #<Addic7ed::Subtitle ... >
#     ]
```

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

A `SubtitlesCollection` instance can be filtered using any method from `Enumerable`, including your good friends `each`, `map`, `select`, `reject`, `find`, `group_by`, `any?`, `count`, `inject`, `sort`, `reduce`, ...

### `Addic7ed::VideoFile`

The `VideoFile` class lets you extract and guess relevant information from a video file name:

```ruby
video = Addic7ed::VideoFile.new("~/Downloads/Game.of.Thrones.S06E09.720p.HDTV.x264-AVS[eztv].mkv")
#=> Guesses for ~/Downloads/Game.of.Thrones.S06E09.720p.HDTV.x264-AVS[eztv].mkv:
#  show:         Game.of.Thrones
#  season:       6
#  episode:      9
#  tags:         ["720P", "HDTV", "X264"]
#  group:        AVS
#  distribution: EZTV
```

## Notes

Addic7ed restricts the number of subtitle download to 15 per 24h (30 per 24h for registered users, and 55 for VIP users). Don't get mad, they have to pay for their servers, you know. Ho, and by the way, please, **please**: do not hammer their servers, play fair!

## Contribute

Feel free to submit a Pull Request, I'd be glad to review/merge it.

Also, if you like the awesome work done by the Addic7ed team, please consider [donating to them](http://www.addic7ed.com) !

### Supported Ruby versions

This project [supports](https://github.com/michaelbaudino/addic7ed-ruby/blob/full-rewrite/.travis.yml) the following Ruby versions/implementations:

* Ruby 2.0 (MRI)
* Ruby 2.1 (MRI)
* Ruby 2.2 (MRI)
* Ruby 2.3 (MRI)
* Ruby 2.4 (MRI)
* Rubinius
* JRuby

:warning: Rubinius users may have to manually install [RubySL](https://github.com/RubySL) before they can use `addic7ed-ruby`:

```shell
$ gem install rubysl
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/michaelbaudino/addic7ed-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct (see `CODE_OF_CONDUCT.md` file).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT) (see `LICENSE.md` file).
