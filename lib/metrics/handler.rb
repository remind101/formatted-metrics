module Metrics
  class Handler
    attr_reader :instrumenters

    def self.handle(*instrumenters)
      new(*instrumenters).handle
    end

    def initialize(*instrumenters)
      @instrumenters = instrumenters.flatten
    end

    def handle
      write instrumenters
    end

  private

    def configuration
      Metrics.configuration
    end

    def write(*args, &block)
      formatter.write(*args, &block)
    end

    def formatter
      configuration.formatter
    end
  
  end
end
