module Metrics
  class Railtie < ::Rails::Railtie
    initializer 'metrics.subscribe' do
      Metrics.subscribe
    end
  end
end
