descendants_tracker
===================

[![Gem Version](https://badge.fury.io/rb/descendants_tracker.png)][gem]
[![Build Status](https://secure.travis-ci.org/dkubb/descendants_tracker.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/dkubb/descendants_tracker.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/dkubb/descendants_tracker.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/dkubb/descendants_tracker/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/descendants_tracker
[travis]: https://travis-ci.org/dkubb/descendants_tracker
[gemnasium]: https://gemnasium.com/dkubb/descendants_tracker
[codeclimate]: https://codeclimate.com/github/dkubb/descendants_tracker
[coveralls]: https://coveralls.io/r/dkubb/descendants_tracker

Small module to track descendants in an unobtrusive way.

Installation
------------

With Rubygems:

```bash
$ gem install descendants_tracker
$ irb -rubygems
>> require 'descendants_tracker'
=> true
```

With git and local working copy:

```bash
$ git clone git://github.com/dkubb/descendants_tracker.git
$ cd descendants_tracker
$ rake install
$ irb -rubygems
>> require 'descendants_tracker'
=> true
```

Examples
--------

``` ruby
class Foo
  extend DescendantsTracker
end

class Bar < Foo
end

Foo.descendants # => [Bar]
```

Credits
-------

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Piotr Solnica ([solnic](https://github.com/solnic))
* Markus Schirp ([mbj](https://github.com/mbj))

Contributing
------------

* If you want your code merged into the mainline, please discuss the proposed changes with me before doing any work on it. This library is still in early development, and the direction it is going may not always be clear. Some features may not be appropriate yet, may need to be deferred until later when the foundation for them is laid, or may be more applicable in a plugin.
* Fork the project.
* Make your feature addition or bug fix.
  * Follow this [style guide](https://github.com/dkubb/styleguide).
* Add specs for it. This is important so I don't break it in a future version unintentionally. Tests must cover all branches within the code, and code must be fully covered.
* Commit, do not mess with Rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Run "rake ci". This must pass and not show any regressions in the metrics for the code to be merged.
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright &copy; 2012-2013 Dan Kubb (author)
Copyright &copy; 2011-2012 Piotr Solnica (source maintainer)
Copyright &copy; 2012 Markus Schirp (packaging)

See LICENSE for details.
