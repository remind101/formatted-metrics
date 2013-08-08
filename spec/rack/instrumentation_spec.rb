require 'spec_helper'

describe Rack::Instrumentation do
  let(:app           ) { double 'app' }
  let(:env           ) { Hash.new }
  let(:response      ) { [200, {}, []] }
  subject(:middleware) { described_class.new app }

  describe '.call' do
    context 'when no error is raised' do
      it 'calls the app' do
        app.should_receive(:call).and_return(response)
        expect(middleware.call(env)).to eq response
      end
    end

    context 'when an error is raised' do
      it 'raises the error' do
        app.should_receive(:call).and_raise
        expect { middleware.call(env) }.to raise_error
      end
    end
  end
end
