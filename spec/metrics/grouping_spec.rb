require 'spec_helper'

describe Metrics::Grouping do
  describe '.instrumenters' do
    it 'builds instruments' do
      group = described_class.new do
        instrument 'jobs.busy', 10
        instrument 'rack.request.time', 500, units: 'ms'
      end

      expect(group.instrumenters).to have(2).instrumenters
    end

    it 'allows a namespace to be provided' do
      group = described_class.new 'rack' do
        instrument 'request.time', 500, units: 'ms'
      end

      expect(group.instrumenters.first.metric).to eq 'rack.request.time'
    end
  end
end
