module Metrics

  # Internal: Responsible for taking a list or an Array of
  # Metrics::Instrumenters and passing them to the driver.
  class Handler
    attr_reader :instrumenters

    def self.handle(*instrumenters)
      new(*instrumenters).handle
    end

    def initialize(*instrumenters)
      @instrumenters = instrumenters
    end

    # Public: Writes all of the instrumenters to the driver.
    #
    # Returns an Array of Metrics::Instrumenters that were written.
    def handle
      return write(*instrumenters)
    end

  private
    def write(*instrumenters)
      driver.write(*instrumenters)
    end

    def driver
      configuration.driver
    end

    def configuration
      Metrics.configuration
    end
  end
end
