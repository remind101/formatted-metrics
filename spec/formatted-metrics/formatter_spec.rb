require 'spec_helper'

describe Metrics::Formatter do
  let(:event    ) { double ActiveSupport::Notifications::Event, name: 'rack.request', payload: { measure: true } }
  let(:formatter) { described_class.new event }

  before do
    formatter.stub_chain :configuration, source: 'app'
  end

  describe '.to_s' do
    subject { formatter.to_s }

    context 'with a duration' do
      before { event.stub duration: 10 }
      it { should eq 'source=app measure.rack.request=10ms' }
    end

    context 'with a measurement' do
      context 'with units' do
        before { event.stub payload: { measure: 1, units: 's' } }
        it { should eq 'source=app measure.rack.request=1s' }
      end

      context 'without units' do
        before { event.stub payload: { measure: 50 } }
        it { should eq 'source=app measure.rack.request=50' }
      end
    end

    context 'with a source' do
      before { event.stub name: 'workers.busy', payload: { measure: 10, source: 'sidekiq' } }
      it { should eq 'source=app.sidekiq measure.workers.busy=10' }
    end
  end
end
