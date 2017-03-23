# Sanelint

This gem encapsulate rubocop config for [Monterail](monterail.com).

## Installation

Add this line to your application's Gemfile:

```ruby
# You don't need to install Rubocop or Rubocop-Rspec - they are added as this gem dependency to
# prevent config from being incompatibile with installed Rubocop version.
gem 'sanelint'
```

And then execute:

    $ bundle

After that you need to add `sanelint` as plugin for Rubocop in your `.rubocop.yml`:

```yaml
inherit_gem:
  sanelint:
    - config/default.yml
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sanelint.

