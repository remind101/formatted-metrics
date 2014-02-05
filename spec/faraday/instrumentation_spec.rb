require 'spec_helper'
require 'faraday/instrumentation'

describe Faraday::Instrumentation do
  let(:response) { double('response', status: 200) }
  let(:app) { double('app', call: response) }
  let(:middleware) { described_class.new(app) }

  describe '.call' do
    let(:uri) { URI.parse('http://google.com') }

    it 'instruments the time it takes' do
      expect(middleware.call(url: uri)).to eq response
    end
  end
end
