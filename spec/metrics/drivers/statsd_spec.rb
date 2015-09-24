require 'spec_helper'
require 'securerandom'

describe Metrics::Drivers::Statsd do
  let(:client) { double }

  def instrumenter(*args)
    Metrics::Instrumenter.new(*args)
  end

  def write(*instrumenters)
    described_class.new(client, '{{name}}.source__{{source}}__', 'app').write(*instrumenters)
  end

  describe '.write' do
    context 'metric types' do
      it 'should call statsd.timing' do
        client.should_receive(:timing).with('rack.request.time.source__app__', 10.3333)
        write(instrumenter('rack.request.time', 10.3333, units: 'ms', type: 'sample'))
      end

      it 'should call statsd.gauge' do
        client.should_receive(:gauge).with('rack.request.size.source__app__', 10)
        write(instrumenter('rack.request.size', 10, type: 'measure'))
      end

      it 'should call statsd.count' do
        client.should_receive(:count).with('foo.bar.source__app__', 10)
        write(instrumenter('foo.bar', 10, type: 'count'))
      end
    end

    context 'metric sources' do
      it 'should insert the globally configured source' do
        client.should_receive(:count).with('foo.bar.source__app__', 10)
        write(instrumenter('foo.bar', 10, type: 'count'))
      end

      it 'should append the instrumenter source' do
        client.should_receive(:count).with('foo.bar.source__app.us__', 10)
        write(instrumenter('foo.bar', 10, type: 'count', source: 'us'))
      end
    end
  end
end
