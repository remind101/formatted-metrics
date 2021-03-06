require 'metrics/middleware_helpers'

module Metrics
  module MiddlewareHelpers
    private

    def request_metrics(status, duration, options = {})
      metric = options[:metric]
      source = options[:source]

      group metric, source: source do |group|
        group.instrument 'time', duration, units: 'ms'

        group.group 'status' do |group|
          group.increment status
          group.increment "#{status.to_s[0]}xx"

          group.instrument "#{status}.time", duration, units: 'ms'
          group.instrument "#{status.to_s[0]}xx.time", duration, units: 'ms'
        end
      end
    end

    def instrument(*args, &block)
      Metrics.instrument(*args, &block)
    end

    def group(namespace, options, &block)
      Metrics.group(namespace, options, &block)
    end
  end
end
