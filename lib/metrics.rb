require 'active_support/core_ext/array/extract_options'
require 'active_support/dependencies/autoload'

require 'metrics/railtie' if defined?(Rails)

module Metrics
  extend ActiveSupport::Autoload

  autoload :Configuration
  autoload :Instrumentable
  autoload :Instrumenter
  autoload :Grouping
  autoload :Handler

  module Formatters
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :L2Met
  end

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
    def instrument(*args, &block)
      Handler.handle(Instrumenter.instrument(*args, &block))
    end

    def group(*args, &block)
      Handler.handle(Grouping.instrument(*args, &block))
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

  end
end
