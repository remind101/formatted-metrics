require 'metrics/middleware_helpers'

module Rack
  class Instrumentation
    include Metrics::MiddlewareHelpers

    def initialize(app)
      @app = app
    end
  
    def call(env)
      begin
        header_metrics env

        time     = Time.now
        response = @app.call(env)
        duration = (Time.now - time) * 1000.0

        request_metrics response.first, duration, metric: 'rack.request'

        response
      rescue Exception => raised
        instrument 'exception', 1, source: 'rack', type: 'count'
        raise
      end
    end

  private

    def header_metrics(env)
      return unless env.keys.include?('HTTP_X_HEROKU_QUEUE_WAIT_TIME')

      instrument 'rack.heroku.queue.wait_time', env['HTTP_X_HEROKU_QUEUE_WAIT_TIME'].to_f, units: 'ms'
    end
  end
end

