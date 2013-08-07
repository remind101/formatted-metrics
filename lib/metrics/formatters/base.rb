module Metrics::Formatters
  class Base
    attr_reader :instrumenters

    def self.write(*instrumenters)
      new(*instrumenters).write
    end

    def initialize(*instrumenters)
      @instrumenters = instrumenters.flatten
    end

    def write
      lines.each do |line|
        configuration.logger.info line
      end
      instrumenters
    end

    def lines
      raise NotImplementedError
    end

  private

    def configuration
      Metrics.configuration
    end

  end
end
