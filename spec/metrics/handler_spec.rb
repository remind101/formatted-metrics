require 'spec_helper'

describe Metrics::Handler do
  let(:args     ) { ['event args'] * 5 }
  let(:handler  ) { described_class.new *args }

  let(:event    ) { double ActiveSupport::Notifications::Event }
  let(:formatter) { double Metrics.configuration.formatter }

  describe '.handle' do
    before do
      ActiveSupport::Notifications::Event.stub new: event
      Metrics.configuration.formatter.stub new: formatter
    end

    context 'when the event is trackable' do
      before do
        event.stub payload: { measure: true }
      end

      it 'should handle the event' do
        Metrics.configuration.stream.should_receive(:puts).with(formatter.to_s)
        handler.handle
      end
    end

    context 'when the event is not trackable' do
      before do
        event.stub payload: { }
      end

      it 'should not handle the event' do
        Metrics.configuration.stream.should_receive(:puts).never
        handler.handle
      end
    end
  end
end
