require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/result'

describe 'Result' do
  before do
  end

  after do
  end

  describe 'test initialize' do
    it 'should have message data and response' do
      mock_response = double('mock_response')
      result = RubyAem::Result.new('somemessage', mock_response)
      result.data = 'somedata'
      expect(result.message).to eq('somemessage')
      expect(result.response).to eq(mock_response)
      expect(result.data).to eq('somedata')
    end
  end
end
