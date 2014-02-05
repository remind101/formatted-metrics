module Sidekiq
  module Middleware
    module Server
      class Instrumentation
        include Metrics::Instrumentable

        def call(worker, item, queue)
          instrument 'sidekiq.job.started', 1, source: ['sidekiq', queue, worker.class.to_s.underscore], type: 'count'
          instrument 'sidekiq.queue.time', source: ['sidekiq', queue, worker.class.to_s.underscore] do
            begin
              yield
            rescue Exception => raised
              instrument 'exception', 1, source: 'sidekiq', type: 'count'
              raise
            end
          end
        end
      end
    end
  end
end
