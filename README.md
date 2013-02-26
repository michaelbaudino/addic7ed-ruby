addic7ed-ruby
=============

Ruby command-line script to fetch subtitles on Addic7ed

Current version: **0.0.3**

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
    $ bundle install
    ```
3. Say you want to download a French subtitle for the last "Californication" episode, all you have to do is :

    ```bash
    $ ./addic7ed.rb -l fr /path/to/Californication.S06E07.720p.HDTV.x264-2HD.mkv
    ```
4. Enjoy your show :tv:

### Changelog

* 0.0.3: Added parsing of command line arguments
* 0.0.2: Added Filename class to analyze filenames and guess showname, season and episode number
* 0.0.1: Initial file structure (Bundler, Rspec, Readme, ...)
