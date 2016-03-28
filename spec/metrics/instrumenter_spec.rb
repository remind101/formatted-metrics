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

  describe '.tags' do
    subject { instrumenter.tags }

    context 'by default' do
      it {should eq Hash.new }
    end

    context 'when specified' do
      let(:instrumenter) { described_class.new('jobs.busy', 10, units: 'jobs', tags: {tag0: 'value0', tag1: 'value1'}) }
      it {should eq({tag0: 'value0', tag1: 'value1'})}
    end
  end

  describe '.result' do
    subject { instrumenter.result }

    context 'with a block' do
      it { should eq 'foo' }
    end

    context 'with a block returning nil' do
      let(:block) { Proc.new { nil } }
      let(:instrumenter) { described_class.new('rack.request', &block) }

      it 'should still memoize the result of the block' do
        block.should_receive(:call).once
        instrumenter.result
        instrumenter.result
      end
    end

    context 'with a value' do
      let(:instrumenter) { described_class.new('jobs.busy', 10, units: 'jobs') }
      it { should be_nil }
    end
  end
end
