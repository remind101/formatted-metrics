module Metrics

  # Internal: Responsible for taking a list or an Array of
  # Metrics::Instrumenters and passing them to the formatter.
  class Handler
    attr_reader :instrumenters

    def self.handle(*instrumenters)
      new(*instrumenters).handle
    end

    def initialize(*instrumenters)
      @instrumenters = instrumenters.flatten
    end

    # Public: Writes all of the instrumenters to STDOUT using the formatter.
    #
    # Returns an Array of Metrics::Instrumenters that were written to STDOUT.
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
