require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/exception'

describe 'Exception' do
  before do
  end

  after do
  end

  describe 'test initialize' do

    it 'should pass message and result' do
      mock_result = double('mock_result')
      exception = RubyAem::Exception.new('somemessage', mock_result)
      expect(exception.message).to eq('somemessage')
      expect(exception.result).to eq(mock_result)
    end

  end

end
