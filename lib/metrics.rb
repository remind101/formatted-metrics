require 'metrics/railtie' if defined?(Rails)

module Metrics
  autoload :Configuration,  'metrics/configuration'
  autoload :Instrumentable, 'metrics/instrumentable'
  autoload :Instrumenter,   'metrics/instrumenter'
  autoload :Grouping,       'metrics/grouping'
  autoload :Handler,        'metrics/handler'

  module Formatters
    autoload :Base,         'metrics/formatters/base'
    autoload :L2Met,        'metrics/formatters/l2met'
  end

  class << self

    # Public: Instrument a metric.
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

    # Public: Group multiple instruments.
    #
    # Example
    #
    #   Metrics.group 'sidekiq' do
    #     instrument 'request.time' do
    #       begin
    #         @app.call(env)
    #       rescue Exception => e
    #         instrument 'exceptions', 1
    #         raise
    #       end
    #     end
    #   end
    #
    # Returns nothing.
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
