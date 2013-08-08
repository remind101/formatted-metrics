module Rack
  class Instrumentation
    def initialize(app)
      @app = app
    end
  
    def call(env)
      begin
        header_metrics env

        time     = Time.now
        response = @app.call(env)
        duration = (Time.now - time) * 1000.0

        request_metrics response.first, duration

        response
      rescue Exception => raised
        instrument 'exception', 1, source: 'rack'
        raise
      end
    end

  private

    def header_metrics(env)
      return unless env.keys.include?('HTTP_X_HEROKU_QUEUE_WAIT_TIME')

      instrument 'rack.heroku.queue.wait_time', env['HTTP_X_HEROKU_QUEUE_WAIT_TIME'].to_f, units: 'ms'
    end

    def request_metrics(status, duration)
      group 'rack.request' do |group|
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

