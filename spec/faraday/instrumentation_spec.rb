require 'spec_helper'
require 'faraday/instrumentation'

describe Faraday::Instrumentation do

  let(:response) { double('response', status: 200) }
  let(:app) { double('app', call: response) }
  let(:middleware) { described_class.new(app) }

  describe '.call' do
    let(:uri) { URI.parse('http://google.com/v1/foo?param=1') }

    it 'returns the response' do
      expect(middleware.call(url: uri)).to eq response
    end

    it 'sets the source' do
      Metrics.should_receive(:group).with('faraday.request', source: 'get').and_call_original
      expect(middleware.call(method: :get, url: uri)).to eq response
    end

    describe 'with path: true' do
      let(:middleware) { described_class.new(app, path: true) }

      it 'includes the path in the source' do
        Metrics.should_receive(:group).with('faraday.request', source: 'get.v1.foo').and_call_original
        expect(middleware.call(method: :get, url: uri)).to eq response
      end
    end
  end
end
