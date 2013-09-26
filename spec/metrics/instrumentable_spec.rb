require 'spec_helper'

describe Metrics::Instrumentable do
  let(:klass) do
    Class.new do
      include Metrics::Instrumentable

      def self.to_s
        'SomeCrazy::Module'
      end

      def initialize
        @foo = 'foo'
      end

      def long_method
        @foo
      end

      def protected_method; end
      def private_method; end

      protected :protected_method
      private :private_method

      instrument :long_method, :protected_method, :private_method
    end
  end

  describe '#instrument' do
    it 'instruments the duration of the method' do
      klass.any_instance.should_receive(:instrument).with('some_crazy.module.long_method').and_yield
      expect(klass.new.long_method).to eq 'foo'
    end

    it 'sets the visibility of protected methods' do
      expect(klass.public_method_defined?(:long_method)).to be_true
    end

    it 'sets the visibility of protected methods' do
      expect(klass.protected_method_defined?(:protected_method)).to be_true
    end

    it 'sets the visibility of private methods' do
      expect(klass.private_method_defined?(:private_method)).to be_true
    end
  end
end
