require 'spec_helper'
require 'securerandom'

describe Metrics::Drivers::DogStatsd do
  let(:client) { double }

  def instrumenter(*args)
    Metrics::Instrumenter.new(*args)
  end

  def write(*instrumenters)
    described_class.new(client, '{{name}}.source__{{source}}__', 'app').write(*instrumenters)
  end

  describe '.write' do

    context 'tag support' do

      it 'should pass an empty tag array if no tags are given' do
        client.should_receive(:timing).with('rack.request.time.source__app__', 10.3333, tags: [])
        write(instrumenter('rack.request.time', 10.3333, units: 'ms', type: 'sample'))
      end

      it 'should pass a tag to the dogstatsd-ruby client' do
        client.should_receive(:gauge).with('rack.request.size.source__app__', 10, tags: ['tag0:long_value_with_lots_of_whitespace'])
        write(instrumenter('rack.request.size', 10, type: 'measure', tags: {tag0: 'long value with lots of whitespace'}))
      end

      it 'should pass multiple tags to the dogstatsd-ruby client' do
        client.should_receive(:count).with('foo.bar.source__app__', 10, tags: ['tag0:value0', 'tag1:value1', 'tag2:value2'])
        write(instrumenter('foo.bar', 10, type: 'count', tags: {tag0: 'value0', tag1: 'value1', tag2: 'value2'}))
      end
    end

  end
end
