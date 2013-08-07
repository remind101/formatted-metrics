require 'spec_helper'

describe Metrics do
  describe '#instrument' do
    it 'delegates to Metrics::Instrumenter' do
      instrumenter = double Metrics::Instrumenter
      Metrics::Instrumenter.should_receive(:instrument).with('rack.request', 10).and_return(instrumenter)
      Metrics::Handler.should_receive(:handle).with(instrumenter)
      Metrics.instrument 'rack.request', 10
    end
  end

  describe '#group' do
    it 'delegates to Metrics::Grouping' do
      grouping = double Metrics::Grouping
      Metrics::Grouping.should_receive(:instrument).and_return(grouping)
      Metrics::Handler.should_receive(:handle).with(grouping)
      Metrics.group { instrument 'rack.request', 10 }
    end
  end
end
