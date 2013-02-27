# addic7ed-ruby [![Build Status](https://travis-ci.org/michaelbaudino/addic7ed-ruby.png)](https://travis-ci.org/michaelbaudino/addic7ed-ruby) [![Dependency Status](https://gemnasium.com/michaelbaudino/addic7ed-ruby.png)](https://gemnasium.com/michaelbaudino/addic7ed-ruby)

Ruby command-line script to fetch subtitles on Addic7ed

Current version: **0.0.5**

### Is it working ?

No. Not yet.

### Usage example

1. Clone the repository:

    ```bash
    $ git clone git://github.com/michaelbaudino/addic7ed-ruby.git
    ```
2. Install dependencies

    ```bash
    $ cd addic7ed-ruby
    $ rvm gemset create addic7ed-ruby # do this only if you use RVM
    $ bundle install
    ```
3. Say you want to download a French subtitle for the last "Californication" episode, all you have to do is :

    ```bash
    $ ./addic7ed.rb -l fr /path/to/Californication.S06E07.720p.HDTV.x264-2HD.mkv
    ```
4. Enjoy your show :tv:

### Changelog

* 0.0.5: Added support for Travis-CI
* 0.0.4: Added retrieving of Addic7ed URL for an episode (including URL for a specific language)
* 0.0.3: Added parsing of command line arguments
* 0.0.2: Added Filename class to analyze filenames and guess showname, season and episode number
* 0.0.1: Initial file structure (Bundler, Rspec, Readme, ...)
