module Metrics::Formatters
  class L2Met < Base
    def lines
      instrumenters.group_by { |instrumenter|
        instrumenter.source
      }.map { |source, instrumenters|
        source = if source
          [configuration.source, source].join('.')
        else
          configuration.source
        end
        ["source=#{source}", instrumenters.map { |instrumenter| "measure.#{instrumenter.metric}=#{instrumenter.value}#{instrumenter.units}" }.join(' ') ]
          .flatten
          .join(' ')
      }
    end
  end
end
