require 'spec_helper'

describe Metrics::Instrumenter do
  let(:instrumenter) { described_class.new('rack.request') { 'foo' } }

  describe '.value' do
    subject { instrumenter.value }

    context 'with a value' do
      let(:instrumenter) { described_class.new('rack.request', 500) }
      it { should eq 500 }
    end

    context 'with a block' do
      before { Time.should_receive(:now).and_return(Time.at(1), Time.at(3)) }
      it { should eq 2000.0 }
    end
  end

  describe '.units' do
    subject { instrumenter.units }

    context 'with a block' do
      it { should eq 'ms' }
    end

    context 'when specified' do
      let(:instrumenter) { described_class.new('jobs.busy', 10, units: 'jobs') }
      it { should eq 'jobs' }
    end
  end

  describe '.source' do
    subject { instrumenter.source }

    context 'by default' do
      it { should be_nil }
    end

    context 'when specified' do
      let(:instrumenter) { described_class.new('jobs.busy', 10, units: 'jobs', source: 'sidekiq') }
      it { should eq 'sidekiq' }
    end
  end

  describe '.result' do
    subject { instrumenter.result }

    context 'with a block' do
      it { should eq 'foo' }
    end

    context 'with a value' do
      let(:instrumenter) { described_class.new('jobs.busy', 10, units: 'jobs') }
      it { should be_nil }
    end
  end
end
