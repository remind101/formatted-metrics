module Metrics::Formatters
  PRECISION = 3.freeze

  class L2Met < Base
    # Example
    # source=web.2 sample#load_avg_1m=0.31 sample#load_avg_5m=0.10 sample#load_avg_15m=0.05
    def lines
      groups.map do |source, instrumenters|
        prefix = "source=#{full_source(source)}"
        measurements = instrumenters.map { |instrumenter| measurement(instrumenter) }
        Lines.new(prefix, measurements).lines
      end.flatten
    end

  private

    # Internal: We group the metrics by their source so that we can separate
    # the lines.
    def groups
      instrumenters.group_by(&:source)
    end

    def full_source(source=nil)
      [configuration.source, source].reject { |s| blank?(s) }.join('.')
    end

    def measurement(instrumenter)
      value = instrumenter.value
      value = value.round(PRECISION) if value.is_a?(Float)
      "#{instrumenter.type}##{instrumenter.metric}=#{value}#{instrumenter.units}"
    end

    def blank?(string)
      string.nil? || string.empty?
    end

    # Responsible for taking a prefix, and an array of measurements, and
    # returning an array of log lines that are limited to 1024 characters per
    # line.
    class Lines
      include Enumerable

      MAX_LEN   = 1024.freeze
      DELIMITER = ' '.freeze

      attr_reader :prefix
      attr_reader :measurements
      attr_reader :max

      def initialize(prefix, measurements)
        @prefix = prefix
        @measurements = measurements
        @max = MAX_LEN - prefix.length + DELIMITER.length * 2
      end

      def each(&block)
        measurements.each(&block)
      end

      def lines
        total = 0
        chunk { |measurement|
          total += measurement.length + DELIMITER.length * 2
          total / max
        }.map { |_, line|
          [prefix, line].join(DELIMITER)
        }
      end
    end
  end
end
