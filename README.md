# Thorney
[Thorney][thorney] is a proposed back-end API for [beta.parliament.uk][beta]. It's built on [Rails][rails], and outputs [JSON][json] which is consumed by [Augustus][augustus].

[![Build Status][shield-travis]][info-travis] [![Test Coverage][shield-coveralls]][info-coveralls] [![License][shield-license]][info-license]

### Contents
<!-- START doctoc -->
<!-- END doctoc -->

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
