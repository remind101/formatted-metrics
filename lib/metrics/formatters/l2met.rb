module Metrics::Formatters
  PRECISION = 3.freeze
  MAX_LEN   = 1024.freeze
  DELIMITER = ' '.freeze

  class L2Met < Base
    # Example
    # source=web.2 sample#load_avg_1m=0.31 sample#load_avg_5m=0.10 sample#load_avg_15m=0.05
    def lines
      groups.map do |source, instrumenters|
        prefix = "source=#{full_source(source)}"
        max = MAX_LEN - prefix.length + DELIMITER.length * 2

        measurements = instrumenters.map { |instrumenter| measurement(instrumenter) }

        limit_line_length(measurements, max).map { |_, line|
          [prefix, line].join(DELIMITER)
        }
      end.flatten
    end

  private

    def limit_line_length(measurements, max)
      total = 0
      measurements.chunk { |measurement|
        total += measurement.length + DELIMITER.length * 2
        total / max
      }
    end

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
  end
end
