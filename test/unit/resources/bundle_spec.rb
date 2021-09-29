require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/bundle'
require_relative '../../../lib/ruby_aem/result'

describe 'Bundle' do
  before do
    @mock_client = double('mock_client')
  end

  after do
  end

  describe 'test start' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Bundle, 'start', name: 'somebundle')
      bundle = RubyAem::Resources::Bundle.new(@mock_client, 'somebundle')
      bundle.start
    end
  end

  describe 'test stop' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Bundle, 'stop', name: 'somebundle')
      bundle = RubyAem::Resources::Bundle.new(@mock_client, 'somebundle')
      bundle.stop
    end
  end

  describe 'test info' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Bundle, 'info', name: 'somebundle')
      bundle = RubyAem::Resources::Bundle.new(@mock_client, 'somebundle')
      bundle.info
    end
  end

  describe 'test is_active' do
    it 'should return true result data when bundle state is active' do
      mock_bundle_data = double('mock_bundle_data')
      expect(mock_bundle_data).to receive(:state).once.and_return('Active')
      mock_bundle_info = double('mock_bundle_info')
      expect(mock_bundle_info).to receive(:data).once.and_return([mock_bundle_data])
      mock_response = double('mock_response')
      mock_result = RubyAem::Result.new('somemessage', mock_response)
      mock_result.data = mock_bundle_info
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Bundle, 'info', name: 'somebundle').and_return(mock_result)
      bundle = RubyAem::Resources::Bundle.new(@mock_client, 'somebundle')
      result = bundle.is_active
      expect(result.data).to eq(true)
      expect(result.message).to eq('Bundle somebundle is active')
    end

    it 'should return false result data when bundle state is active' do
      mock_bundle_data = double('mock_bundle_data')
      expect(mock_bundle_data).to receive(:state).once.and_return('Resolved')
      mock_bundle_info = double('mock_bundle_info')
      expect(mock_bundle_info).to receive(:data).once.and_return([mock_bundle_data])
      mock_response = double('mock_response')
      mock_result = RubyAem::Result.new('somemessage', mock_response)
      mock_result.data = mock_bundle_info
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Bundle, 'info', name: 'somebundle').and_return(mock_result)
      bundle = RubyAem::Resources::Bundle.new(@mock_client, 'somebundle')
      result = bundle.is_active
      expect(result.data).to eq(false)
      expect(result.message).to eq('Bundle somebundle is not active. Bundle state is Resolved')
    end
  end
end
