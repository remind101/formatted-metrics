module Metrics::Drivers
  class DogStatsd < Statsd

    def emit(instrumenter)
      name = name_for(instrumenter)
      value = instrumenter.value
      tags = formatted_tags(instrumenter.tags)

      case instrumenter.type
        when 'histogram'
          client.histogram(name, value, tags: tags)
        when 'measure', 'sample'
          if instrumenter.units == 'ms'
            client.timing(name, value, tags: tags)
          else
            client.gauge(name, value, tags: tags)
          end
        when 'count'
          client.count(name, value, tags: tags)
        else
          raise ArgumentError.new("unsupported instrumenter type for dogstatsd: '%s'" % instrumenter.type)
      end
    end

    private

    def formatted_tags(tags)
      tags.map { |k, v| "%s:%s" % [k, v.tr(' ', '_')] }
    end

  end
end
