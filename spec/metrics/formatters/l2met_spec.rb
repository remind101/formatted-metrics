require 'spec_helper'

describe Metrics::Formatters::L2Met do
  let(:formatter) { described_class.new *instrumenters }

  before do
    Metrics.configuration.stub source: 'app'
  end

  def instrumenter(values)
    double Metrics::Instrumenter, { source: nil, type: 'measure' }.merge(values)
  end

  describe '.lines' do
    subject(:format) { formatter.lines }

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
  end
end
