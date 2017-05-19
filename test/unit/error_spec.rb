require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/error'

describe 'Error' do
  before do
  end

  after do
  end

  describe 'test initialize' do
    it 'should pass message and result' do
      mock_result = double('mock_result')
      err = RubyAem::Error.new('somemessage', mock_result)
      expect(err.message).to eq('somemessage')
      expect(err.result).to eq(mock_result)
    end
  end
end
