require 'spec_helper'

describe Metrics do
  let(:instrumenter) { ActiveSupport::Notifications }

  describe '#instrument' do
    context 'with a block' do
      it 'instruments the duration' do
        instrumenter.should_receive(:instrument).with('rack.request', measure: true, source: nil)
        Metrics.instrument 'rack.request' do
          'foo'
        end
      end

      it 'instruments the duration with a source' do
        instrumenter.should_receive(:instrument).with('rack.request', measure: true, source: 'foo')
        Metrics.instrument 'rack.request', source: 'foo' do
          'do something long'
        end
      end
    end

    context 'with a measurement' do
      it 'instruments the measurement' do
        instrumenter.should_receive(:instrument).with('rack.request', measure: 10, source: nil)
        Metrics.instrument 'rack.request', 10
      end

      it 'instruments the measurement with a source' do
        instrumenter.should_receive(:instrument).with('rack.request', measure: 10, source: 'foo')
        Metrics.instrument 'rack.request', 10, source: 'foo'
      end
    end
  end
end
