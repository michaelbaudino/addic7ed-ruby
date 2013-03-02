# addic7ed-ruby [![Build Status](https://travis-ci.org/michaelbaudino/addic7ed-ruby.png)](https://travis-ci.org/michaelbaudino/addic7ed-ruby) [![Dependency Status](https://gemnasium.com/michaelbaudino/addic7ed-ruby.png)](https://gemnasium.com/michaelbaudino/addic7ed-ruby)

Ruby command-line script to fetch subtitles on Addic7ed

Current version: **0.0.7**

### Is it working ?

Well, it should...

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

* 0.0.7: Added ability to actually download a subtitle
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