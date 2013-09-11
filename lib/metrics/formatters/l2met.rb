module Metrics::Formatters
  PRECISION = 3

  class L2Met < Base
    # Example
    # source=web.2 sample#load_avg_1m=0.31 sample#load_avg_5m=0.10 sample#load_avg_15m=0.05
    def lines
      groups.map do |source, instrumenters|
        [
          "source=#{full_source(source)}",
          instrumenters.map { |instrumenter| measurement(instrumenter) }.join(' ')
        ].flatten.join(' ')
      end
    end

  private

    # Internal: We group the metrics by their source so that we can separate
    # the lines.
    def groups
      instrumenters.group_by(&:source)
    end

    def full_source(source=nil)
      if source
        [configuration.source, source].join('.')
      else
        configuration.source
      end
    end

    def measurement(instrumenter)
      value = instrumenter.value
      value = value.round(PRECISION) if value.is_a?(Float)
      "#{instrumenter.type}##{instrumenter.metric}=#{value}#{instrumenter.units}"
    end
  end
end
