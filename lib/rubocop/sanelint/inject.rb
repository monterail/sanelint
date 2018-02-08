module RuboCop
  module Sanelint
    # After
    #   https://github.com/nevir/rubocop-rspec/blob/v1.4.1/lib/rubocop/rspec/inject.rb
    #   https://github.com/caskroom/rubocop-cask/blob/v0.6.1/lib/rubocop/cask/inject.rb
    # Because RuboCop doesn't yet support plugins, we have to monkey patch in a
    # bit of our configuration.
    module Inject
      DEFAULT_FILE = File.expand_path(
        "../../../../config/default.yml", __FILE__
      )

      def self.defaults!
        hash = ConfigLoader.send(:load_yaml_configuration, DEFAULT_FILE)
        config = Config.new(hash, DEFAULT_FILE)
        puts "configuration from #{DEFAULT_FILE}" if ConfigLoader.debug?
        config = ConfigLoader.merge_with_default(config, DEFAULT_FILE)

        ConfigLoader.instance_variable_set(:@default_configuration, config)
      end
    end
  end
end
