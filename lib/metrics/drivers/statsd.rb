module Metrics::Drivers
  class Statsd
    attr_reader :client, :template, :source_prefix

    def initialize(client, template, source_prefix)
      @client        = client        # The statsd client
      @template      = template      # The template for the metric name
      @source_prefix = source_prefix # Source prefix
    end

    def write(*instrumenters)
      instrumenters.each do |instrumenter|
        emit(instrumenter)
      end
      instrumenters
    end

    def emit(instrumenter)
      name = name_for(instrumenter)
      value = instrumenter.value

      case instrumenter.type
      when 'measure', 'sample'
        if instrumenter.units == 'ms'
          client.timing(name, value)
        else
          client.gauge(name, value)
        end
      when 'count'
        client.count(name, value)
      else
        raise ArgumentError.new("unsupported instrumenter type for statsd: '%s'" % instrumenter.type)
      end
    end

    private

    def name_for(instrumenter)
      template.gsub('{{name}}', instrumenter.metric).gsub('{{source}}', source(instrumenter))
    end

    def source(instrumenter)
      [source_prefix, instrumenter.source].compact.join('.')
    end
  end
end
