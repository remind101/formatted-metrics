module Metrics::Formatters
  class L2Met < Base
    def lines
      groups.map do |source, instrumenters|
        [
          "source=#{full_source(source)}",
          instrumenters.map { |instrumenter| "measure.#{instrumenter.metric}=#{instrumenter.value}#{instrumenter.units}" }.join(' ')
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
  end
end
