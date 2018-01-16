# TODO

Here is a list of future features I'd like to implement.

> :innocent: It's also an interesting list of tasks to pickup if you'd like to contribute.

## For 4.0 (the full-rewrite)

* [x] move download logic to a service object
* [x] add a new `Search` model
* [x] move compatibility logic to a `CheckCompatibility` service object
* [x] create a `SubtitlesCollection` class to hold and filter subtitles
* [x] move best subtitle logic to `SubtitlesCollection`
* [x] rename `Subtitle#via` to `Subtitle#source`
* [x] refactor how `Episode` holds `Subtitle`s
* [x] rename `ShowList` and make it a service object
* [x] write code documentation
* [x] configure GitHub hook for [RubyDoc](http://www.rubydoc.info)
* [x] add `bin/console`
* [x] remove `bin/addic7ed`
* [x] use symbols rather than strings for languages
* [x] add Rubocop
* [x] move user agents and languages to a config file
* [x] add a Bundler post-install message to notify users that this gem is no longer providing a CLI
* [x] switch to using the language-neutral page
* [x] update README to include only API stuff
* [ ] maybe remove `SHOWS_URL` and `EPISODES_URL`
* [ ] mention documentation generation in `README`
* [x] add support for MRI 2.5
* [ ] move CLI to a separate gem (including `DownloadSubtitle`) using Thor
* [ ] Use `HTTParty` or `Faraday` instead of custom HTTP  download code
* [x] remove all `to_s` and `to_inspect` methods
* [ ] update links/badges to the `full-rewrite` branch in `README.md` to use `master`
* [ ] release `4.0` :champagne:

## More features

* [ ] refactor errors (to match Ruby errors hierarchy and maybe allow both bang-erroring and not-erroring versions of public API methods)
* [x] refactor how HI works (allow both "no HI", "force HI" and "don't care")
* [ ] add specs for HTML parsing
* [ ] support registered users (to avoid download throttle)
