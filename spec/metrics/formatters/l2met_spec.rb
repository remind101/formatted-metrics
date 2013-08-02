require 'spec_helper'

describe Metrics::Formatters::L2Met do
  let(:formatter) { described_class.new *instrumenters }

  before do
    Metrics.configuration.stub source: 'app'
  end

  def instrumenter(values)
    double Metrics::Instrumenter, { source: nil }.merge(values)
  end

  describe '.lines' do
    subject(:format) { formatter.lines }

    context 'with a single instrumenter' do
      let(:instrumenters) { [ instrumenter(metric: 'rack.request.time', value: 10, units: 'ms') ] }
      it { should eq ['source=app measure.rack.request.time=10ms'] }
    end

    context 'with multiple instrumenters' do
      let(:instrumenters) do
        [ instrumenter(metric: 'rack.request.time', value: 10, units: 'ms'),
          instrumenter(metric: 'jobs.busy', value: 10, units: 'jobs') ]
      end

      it { should eq ['source=app measure.rack.request.time=10ms measure.jobs.busy=10jobs'] }
    end

    context 'with multiple metrics from different sources' do
      let(:instrumenters) do
        [ instrumenter(metric: 'rack.request.time', value: 10, units: 'ms'),
          instrumenter(metric: 'jobs.queued', value: 15, units: 'jobs', source: 'foo'),
          instrumenter(metric: 'jobs.busy', value: 10, units: 'jobs', source: 'foo') ]
      end

      it { should eq ['source=app measure.rack.request.time=10ms', 'source=app.foo measure.jobs.queued=15jobs measure.jobs.busy=10jobs'] }
    end
  end
end
