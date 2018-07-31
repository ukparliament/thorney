# Thorney
[Thorney][thorney] is a proposed back-end API for [beta.parliament.uk][beta]. It's built on [Rails][rails], and outputs [JSON][json] which is consumed by [Augustus][augustus].

[![Build Status][shield-travis]][info-travis] [![Test Coverage][shield-coveralls]][info-coveralls] [![License][shield-license]][info-license]

### Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Requirements](#requirements)
- [Quick start](#quick-start)
- [Running the application](#running-the-application)
- [Using Docker Compose to run both Thorney and Augustus](#using-docker-compose-to-run-both-thorney-and-augustus)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Requirements
[Thorney][thorney] requires the following:
* [Ruby][ruby] - [click here][ruby-version] for the exact version
* [Bundler][bundler]

## Quick start
```bash
git clone https://github.com/ukparliament/thorney.git
cd thorney
bundle install
bundle exec rake
```

## Running the application
To run the application locally, run:

```bash
bundle exec rails s
```

The application should now be available at [http://localhost:3000][local].

By default, there is a service timeout of 5 seconds. This can be disabled by setting the `DISABLE_TIMEOUT` environment variable to `true`, like so:

```bash
DISABLE_TIMEOUT=true bundle exec rails s
```

## Using Docker Compose to run both Thorney and Augustus
Make sure to clone [Thorney][thorney] and [Augustus][augustus] into the same directory and then change into the directory that [Thorney][thorney] is in. 

```bash
git clone https://github.com/ukparliament/thorney.git
git clone https://github.com/ukparliament/augustus.git
cd thorney
```

Your folder structure should look like this:

```bash
/example_folder
    /thorney
    /augustus
```

To run both Thorney and Augustus, you will need to run the following commands from within the [Thorney][thorney] directory. Set up the application using:

```bash
docker-compose build --no-cache
```

Start the application using:

```bash
docker-compose up
```

The application will then be available from http://localhost:5400/.

## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Fork the repository
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Ensure your changes are tested using [Rspec][rspec]
1. Create a new Pull Request

## License
[Thorney][thorney] is licensed under [MIT][info-license].

.

[thorney]: https://github.com/ukparliament/thorney
[beta]: https://beta.parliament.uk
[rails]: https://rubyonrails.org
[json]: http://json.org
[augustus]: https://github.com/ukparliament/augustus
[ruby]: https://www.ruby-lang.org/en/
[ruby-version]: https://github.com/ukparliament/thorney/blob/master/.ruby-version
[bundler]: https://bundler.io
[local]: http://localhost:3000
[rspec]: http://rspec.info


[info-travis]:   https://travis-ci.org/ukparliament/thorney
[shield-travis]: https://img.shields.io/travis/ukparliament/thorney.svg

[info-coveralls]:   https://coveralls.io/github/ukparliament/thorney
[shield-coveralls]: https://img.shields.io/coveralls/ukparliament/thorney.svg

[info-license]:   https://github.com/ukparliament/thorney/blob/master/LICENSE
[shield-license]: https://img.shields.io/badge/license-MIT-blue.svg
