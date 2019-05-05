require 'spec_helper'
require 'faraday/instrumentation'

describe Faraday::Instrumentation do

  class Response
    def initialize(env)
      @env = env
    end

    def status
      200
    end

    def on_complete
      yield @env
      self
    end
  end

  class App
    def initialize(response)
      @response = response
    end

    def call(env)
      env[:response] = @response
    end
  end

  describe '.call' do
    let(:uri) { URI.parse('http://google.com/v1/foo?param=1') }
    let(:env) { { method: :get, url: uri } }
    let(:response) { Response.new(env) }
    let(:app) { App.new(response) }
    let(:middleware) { described_class.new(app) }

    it 'returns the response' do
      expect(middleware.call(env)).to eq response
    end

    it 'sets the source' do
      Metrics.should_receive(:group).with('faraday.request', source: 'get').and_call_original
      expect(middleware.call(env)).to eq response
    end

    describe 'with path: true' do
      let(:middleware) { described_class.new(app, path: true) }

      it 'includes the path in the source' do
        Metrics.should_receive(:group).with('faraday.request', source: 'get.v1.foo').and_call_original
        expect(middleware.call(env)).to eq response
      end
    end
  end
end
