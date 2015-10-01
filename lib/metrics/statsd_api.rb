module Metrics
  # This adds a statsd compatible api that delegates back to #instrument
  module StatsdApi
    def increment(stat, options = {})
      instrument stat, 1, options.merge(type: 'count')
    end

    def decrement(stat, options = {})
      instrument stat, -1, options.merge(type: 'count')
    end

    def count(stat, count, options = {})
      instrument stat, count, options.merge(type: 'count')
    end

    def gauge(stat, value, options = {})
      instrument stat, value, options.merge(type: 'measure')
    end

    def histogram(stat, value, options = {})
      instrument stat, value, options.merge(type: 'histogram')
    end

    def timing(stat, ms, options = {})
      instrument stat, ms, options.merge(type: 'measure', units: 'ms')
    end

    def time(stat, options = {})
      instrument stat, options do
        yield
      end
    end
  end
end