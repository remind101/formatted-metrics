require 'spec_helper'

class StatsdApiTest
  extend Metrics::StatsdApi
end

describe Metrics::StatsdApi do

  describe '#increment' do
    it 'delegates to instrument' do
      StatsdApiTest.should_receive(:instrument).with('rack.request', 1, type: 'count')
      StatsdApiTest.increment('rack.request')
    end
  end

  describe '#decrement' do
    it 'delegates to instrument' do
      StatsdApiTest.should_receive(:instrument).with('rack.request', -1, type: 'count')
      StatsdApiTest.decrement('rack.request')
    end
  end

  describe '#count' do
    it 'delegates to instrument' do
      StatsdApiTest.should_receive(:instrument).with('rack.request', 10, type: 'count')
      StatsdApiTest.count('rack.request', 10)
    end
  end

  describe '#gauge' do
    it 'delegates to instrument' do
      StatsdApiTest.should_receive(:instrument).with('rack.request', 100, type: 'measure')
      StatsdApiTest.gauge('rack.request', 100)
    end
  end

  describe '#histogram' do
    it 'delegates to instrument' do
      StatsdApiTest.should_receive(:instrument).with('rack.request', 100, type: 'histogram')
      StatsdApiTest.histogram('rack.request', 100)
    end
  end

  describe '#timing' do
    it 'delegates to instrument' do
      StatsdApiTest.should_receive(:instrument).with('rack.request.latency', 1000, type: 'measure', units: 'ms')
      StatsdApiTest.timing('rack.request.latency', 1000)
    end
  end

  describe '#time' do
    it 'delegates to instrument' do
      StatsdApiTest.should_receive(:instrument).with('rack.request.latency', {}).and_yield
      StatsdApiTest.time('rack.request.latency') { }
    end
  end
end