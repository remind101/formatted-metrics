require 'spec_helper'
require 'faraday/instrumentation'

describe Faraday::Instrumentation do
  let(:response) { double('response', status: 200) }
  let(:app) { double('app', call: response) }
  let(:middleware) { described_class.new(app) }

  describe '.call' do
    it 'instruments the time it takes' do
      expect(middleware.call(url: 'http://api')).to eq response
    end
  end
end
