require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/truststore'

describe 'Truststore' do
  before do
    @mock_client = double('mock_client')
    @truststore = RubyAem::Resources::Truststore.new(@mock_client)
  end

  describe 'test create' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'create',
        { password: 's0m3p4ssw0rd' }
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
        { file_path: '/somepath' }
      )
      @truststore.download('/somepath')
    end
  end

  describe 'test upload' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'upload',
        {
          file_path: '/somepath',
          force: true
        }
      )
      @truststore.upload('/somepath')
    end
  end

  describe 'test read' do
    it 'should read truststore file and convert it to PKCS12 truststore' do
      mock_truststore = double('mock_truststore')
      allow(File).to receive(:read).and_call_original
      expect(File).to receive(:read).with('/somepath').and_return('sometruststoreraw')
      expect(OpenSSL::PKCS12).to receive(:new).with('sometruststoreraw', 's0m3p4ssw0rd').and_return(mock_truststore)

      truststore = @truststore.read('/somepath', 's0m3p4ssw0rd')
      expect(truststore).to be(mock_truststore)
    end
  end

  describe 'test upload_wait_until_ready' do
    it 'should upload then check existence until truststore exists' do
      mock_result_upload = double('mock_result_upload')
      mock_result_not_exists = double('mock_result_not_exists')
      expect(mock_result_not_exists).to receive(:data).twice.and_return(false)
      expect(mock_result_not_exists).to receive(:message).twice.and_return('Truststore not found')
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).twice.and_return(true)
      expect(mock_result_exists).to receive(:message).and_return('Truststore exists')

      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'upload',
        {
          file_path: '/somepath',
          force: false
        }
      ).and_return(mock_result_upload)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Truststore, 'exists', anything).and_return(mock_result_not_exists)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Truststore, 'exists', anything).and_return(mock_result_exists)

      expect($stdout).to receive(:puts).with('Upload check #1: false - Truststore not found')
      expect($stdout).to receive(:puts).with('Upload check #2: true - Truststore exists')
      result = @truststore.upload_wait_until_ready(
        '/somepath',
        force: false,
        _retries: {
          max_tries: '3',
          base_sleep_seconds: '0',
          max_sleep_seconds: '0'
        }
      )
      expect(result).to be(mock_result_upload)
    end

    it 'should use default force and retries settings when they are not specified' do
      mock_result_upload = double('mock_result_upload')
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).twice.and_return(true)
      expect(mock_result_exists).to receive(:message).and_return('Truststore exists')

      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Truststore,
        'upload',
        {
          file_path: '/somepath',
          force: true
        }
      ).and_return(mock_result_upload)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Truststore, 'exists', anything).and_return(mock_result_exists)

      expect($stdout).to receive(:puts).with('Upload check #1: true - Truststore exists')
      result = @truststore.upload_wait_until_ready('/somepath')
      expect(result).to be(mock_result_upload)
    end
  end
end
