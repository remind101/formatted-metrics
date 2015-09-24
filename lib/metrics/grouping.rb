module Metrics
  # Public: Starts a new Grouping context, which allows for multiple
  # instruments to output on a single line.
  class Grouping
    attr_reader :namespace, :instrumenters, :options

    def self.instrument(namespace = nil, options = {}, &block)
      new(namespace, options, &block).instrumenters
    end

    def initialize(namespace = nil, options = {}, &block)
      @instrumenters = []
      @namespace     = namespace
      @options       = options
      block.call(self)
    end

    def increment(metric)
      instrument metric, 1, options.merge(type: 'count')
    end

    def instrument(metric, *args, &block)
      metric = "#{namespace}.#{metric}" if namespace
      instrumenters.push(Instrumenter.instrument(metric, *merge_options(args), &block))
    end

    def group(nested_namespace = nil, *args, &block)
      ns = nested_namespace ? "#{namespace}.#{nested_namespace}" : namespace
      instrumenters.push(*Grouping.instrument(ns, *merge_options(args), &block))
    end

  private

    def merge_options(args)
      opts = extract_options!(args)
      args << options.merge(opts)
      args
    end

    def extract_options!(options)
      Metrics::Helpers.extract_options!(options)
    end

  end
end
