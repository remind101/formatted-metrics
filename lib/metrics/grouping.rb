module Metrics
  # Public: Starts a new Grouping context, which allows for multiple
  # instruments to output on a single line.
  class Grouping
    attr_reader :namespace, :instrumenters
    
    def self.instrument(*args, &block)
      new(*args, &block).instrumenters
    end

    def initialize(namespace = nil, &block)
      @instrumenters = []
      @namespace     = namespace
      block.call(self)
    end

    def instrument(metric, *args, &block)
      metric = "#{namespace}.#{metric}" if namespace
      instrumenters << Instrumenter.instrument(metric, *args, &block)
    end
  end
end
