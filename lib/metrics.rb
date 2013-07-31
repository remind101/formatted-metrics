require 'active_support/notifications'
require 'active_support/core_ext/array/extract_options'
require 'active_support/dependencies/autoload'

require 'metrics/railtie' if defined?(Rails)

module Metrics
  extend ActiveSupport::Autoload

  autoload :Configuration
  autoload :Handler
  autoload :Formatter

  class << self

    # Public: Instrument a metric.
    #
    # metric - The name of the metric (e.g. rack.request)
    # source - A source to append to the default source.
    #
    # Example
    #
    #   # Instrument the duration of an event.
    #   Metrics.instrument 'rack.request' do
    #     @app.call(env)
    #   end
    #
    #   # Instrument a specific value.
    #   Metrics.instrument 'workers.busy', 10, units: 'workers'
    #
    #   # Instrument something with a specific source.
    #   Metrics.instrument 'sidekiq.queue', source: 'background' do
    #     yield
    #   end
    #
    # Returns nothing.
    def instrument(metric, *args, &block)
      options = args.extract_options!

      measure = if args.empty?
        block_given? ? true : 1
      else
        args.first
      end

      ActiveSupport::Notifications.instrument(
        metric,
        options.merge(measure: measure, source: options[:source]),
        &block
      )
    end

    # Public: Subscribe to all ActiveSupport::Notifications events. Only events
    # that have a payload with a :measure key that is truthy will be processed
    # and logged to stdout.
    #
    # Example
    #
    #   Metrics.setup
    #
    # Returns nothing.
    def subscribe
      ActiveSupport::Notifications.subscribe /.*/ do |*args|
        Metrics::Handler.new(*args).handle
      end
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

  end
end
