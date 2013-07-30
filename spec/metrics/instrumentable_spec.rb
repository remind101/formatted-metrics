require 'spec_helper'

describe Metrics::Instrumentable do
  let(:klass) do
    Class.new do
      include Metrics::Instrumentable

      def self.to_s
        'Some::Module'
      end

      def initialize
        @foo = 'foo'
      end

      def long_method
        @foo
      end

      instrument :long_method
    end
  end

  describe '#instrument' do
    it 'instruments the duration of the method' do
      klass.any_instance.should_receive(:instrument).with('some.module.long_method').and_yield
      expect(klass.new.long_method).to eq 'foo'
    end
  end
end
