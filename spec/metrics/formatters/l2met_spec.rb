require 'spec_helper'
require 'securerandom'

describe Metrics::Formatters::L2Met do
  let(:formatter) { described_class.new *instrumenters }

  before do
    Metrics.configuration.stub source: 'app'
  end

  def instrumenter(values)
    double Metrics::Instrumenter, { source: nil, type: 'measure' }.merge(values)
  end

  describe '.lines' do
    subject(:lines) { formatter.lines }

    context 'with a single instrumenter' do
      let(:instrumenters) { [ instrumenter(metric: 'rack.request.time', value: 10.3333, units: 'ms', type: 'sample') ] }
      it { should eq ['source=app sample#rack.request.time=10.333ms'] }
    end

    context 'with multiple instrumenters' do
      let(:instrumenters) do
        [ instrumenter(metric: 'rack.request.time', value: 10, units: 'ms'),
          instrumenter(metric: 'jobs.busy', value: 10, units: 'jobs') ]
      end

      it { should eq ['source=app measure#rack.request.time=10ms measure#jobs.busy=10jobs'] }
    end

    context 'with multiple metrics from different sources' do
      let(:instrumenters) do
        [ instrumenter(metric: 'rack.request.time', value: 10, units: 'ms', type: 'sample'),
          instrumenter(metric: 'jobs.queued', value: 15, units: 'jobs', source: 'foo', type: 'count'),
          instrumenter(metric: 'jobs.busy', value: 10, units: 'jobs', source: 'foo', type: 'count') ]
      end

      it { should eq ['source=app sample#rack.request.time=10ms', 'source=app.foo count#jobs.queued=15jobs count#jobs.busy=10jobs'] }
    end

    context 'with lots of metrics from the same source' do
      let(:instrumenters) do
        100.times.map { instrumenter(metric: SecureRandom.hex, value: rand(100), units: 'ms', type: 'sample') }
      end

      it 'limits each line to 1024 characters' do
        lines.each do |line|
          expect(line.length).to be < 1024
        end
      end
    end
  end
end
