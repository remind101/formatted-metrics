require 'metrics/middleware_helpers'

module Metrics
  module MiddlewareHelpers
    private

    def request_metrics(namespace, status, duration)
      group namespace do |group|
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

    def group(*args, &block)
      Metrics.group(*args, &block)
    end
  end
end
