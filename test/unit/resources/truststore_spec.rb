require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/truststore'

describe 'Truststore' do
  before do
    @mock_client = double('mock_client')
    @truststore = RubyAem::Resources::Truststore.new(@mock_client)
  end

  after do
  end

  describe 'test create' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'create',
        password: 's0m3p4ssw0rd'
      )
      @truststore.create('s0m3p4ssw0rd')
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'delete',
        {}
      )
      @truststore.delete
    end
  end

  describe 'test exists' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'exists',
        {}
      )
      @truststore.exists
    end
  end

  describe 'test info' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'info',
        {}
      )
      @truststore.info
    end
  end

  describe 'test download' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'download',
        file_path: '/somepath'
      )
      @truststore.download('/somepath')
    end
  end

  describe 'test upload' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'upload',
        file_path: '/somepath',
        force: true
      )
      @truststore.upload('/somepath')
    end
  end
end
