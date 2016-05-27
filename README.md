# Sanelint

This gem encapsulate rubocop config for [Monterail](monterail.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sanelint'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sanelint

## Usage

You need to tell RuboCop to load the Sanelint config. There are three ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`:

```yaml
require: rubocop-cask
```

Now you can run `rubocop` and it will automatically load the RuboCop Cask cops together with the standard cops.

### Command line

```bash
rubocop --require rubocop-cask
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-cask'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sanelint.

