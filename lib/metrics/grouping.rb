module Metrics
  class Grouping
    attr_reader :namespace, :instrumenters
    
    def self.instrument(*args, &block)
      new(*args, &block).instrumenters
    end

    def initialize(namespace = nil, &block)
      @instrumenters = []
      @namespace     = namespace
      instance_eval &block
    end

    def instrument(metric, *args, &block)
      metric = "#{namespace}.#{metric}" if namespace
      instrumenters << Instrumenter.instrument(metric, *args, &block)
    end
  end
end
