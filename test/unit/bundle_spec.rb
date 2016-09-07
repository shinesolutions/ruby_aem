require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/bundle'

describe 'Bundle' do
  before do
    @mock_client = double('mock_client')
  end

  after do
  end

  describe 'test start' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(RubyAem::Bundle, 'start', { :name => 'somebundle' })
      bundle = RubyAem::Bundle.new(@mock_client, 'somebundle')
      bundle.start
    end

  end

  describe 'test stop' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(RubyAem::Bundle, 'stop', { :name => 'somebundle' })
      bundle = RubyAem::Bundle.new(@mock_client, 'somebundle')
      bundle.stop
    end

  end

end
