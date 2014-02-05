require 'metrics'
require 'faraday'

module Faraday
  class Instrumentation < Faraday::Middleware
    include Metrics::MiddlewareHelpers

    def initialize(app, options = {})
      super(app)
      @options = { metric: 'faraday.request' }.merge(options)
    end

    def call(env)
      time = Time.now
      response = @app.call(env)
      duration = (Time.now - time) * 1000.0

      request_metrics response.status, duration, metric: metric, source: env[:url]

      response
    end

  private
    attr_reader :options

    def metric
      options[:metric]
    end
  end
end
