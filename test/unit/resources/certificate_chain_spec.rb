require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/certificate_chain'

describe 'CertificateChain' do
  before do
    @mock_client = double('mock_client')
    @certificate_chain = RubyAem::Resources::CertificateChain.new(@mock_client, 'someprivatekeyalias', '/home/users/system/', 'authentication-service')
  end

  describe 'test create' do
    it 'should call client with expected parameters' do
      mock_result = double('mock_result')
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::CertificateChain,
        'import',
        {
          private_key_alias: 'someprivatekeyalias',
          keystore_intermediate_path: 'home/users/system',
          keystore_authorizable_id: 'authentication-service',
          file_path_certificate: '/somepath/cert_chain.crt',
          file_path_private_key: '/somepath/private_key.der'
        }
      ).and_return(mock_result)
      result = @certificate_chain.create('/somepath/cert_chain.crt', '/somepath/private_key.der')
      expect(result).to be(mock_result)
    end
  end

  describe 'test import' do
    it 'should call client with expected parameters' do
      mock_result = double('mock_result')
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::CertificateChain,
        'import',
        {
          private_key_alias: 'someprivatekeyalias',
          keystore_intermediate_path: 'home/users/system',
          keystore_authorizable_id: 'authentication-service',
          file_path_certificate: '/somepath/cert_chain.crt',
          file_path_private_key: '/somepath/private_key.der'
        }
      ).and_return(mock_result)
      result = @certificate_chain.import('/somepath/cert_chain.crt', '/somepath/private_key.der')
      expect(result).to be(mock_result)
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters when certificate chain exists' do
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).and_return(true)
      mock_result_delete = double('mock_result_delete')
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::CertificateChain,
        'exists',
        {
          private_key_alias: 'someprivatekeyalias',
          keystore_intermediate_path: 'home/users/system',
          keystore_authorizable_id: 'authentication-service'
        }
      ).and_return(mock_result_exists)
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::CertificateChain,
        'delete',
        {
          private_key_alias: 'someprivatekeyalias',
          keystore_intermediate_path: 'home/users/system',
          keystore_authorizable_id: 'authentication-service'
        }
      ).and_return(mock_result_delete)
      result = @certificate_chain.delete
      expect(result).to be(mock_result_delete)
    end

    it 'should raise error when certificate chain does not exist' do
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).and_return(false)
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::CertificateChain,
        'exists',
        {
          private_key_alias: 'someprivatekeyalias',
          keystore_intermediate_path: 'home/users/system',
          keystore_authorizable_id: 'authentication-service'
        }
      ).and_return(mock_result_exists)
      expect { @certificate_chain.delete }.to raise_error(RubyAem::Error) { |error|
        expect(error.message).to eq('Certificate chain not found')
        expect(error.result).to be(mock_result_exists)
      }
    end
  end

  describe 'test exists' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::CertificateChain,
        'exists',
        {
          private_key_alias: 'someprivatekeyalias',
          keystore_intermediate_path: 'home/users/system',
          keystore_authorizable_id: 'authentication-service'
        }
      )
      @certificate_chain.exists
    end
  end

  describe 'test import_wait_until_ready' do
    it 'should import then check existence until certificate chain exists' do
      mock_result_import = double('mock_result_import')
      mock_result_not_exists = double('mock_result_not_exists')
      expect(mock_result_not_exists).to receive(:data).twice.and_return(false)
      expect(mock_result_not_exists).to receive(:message).twice.and_return('Certificate chain not found')
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).twice.and_return(true)
      expect(mock_result_exists).to receive(:message).and_return('Certificate chain exists')

      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::CertificateChain, 'import', anything).and_return(mock_result_import)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::CertificateChain, 'exists', anything).and_return(mock_result_not_exists)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::CertificateChain, 'exists', anything).and_return(mock_result_exists)

      expect($stdout).to receive(:puts).with('Import check #1: false - Certificate chain not found')
      expect($stdout).to receive(:puts).with('Import check #2: true - Certificate chain exists')
      result = @certificate_chain.import_wait_until_ready(
        '/somepath/cert_chain.crt',
        '/somepath/private_key.der',
        _retries: {
          max_tries: '3',
          base_sleep_seconds: '0',
          max_sleep_seconds: '0'
        }
      )
      expect(result).to be(mock_result_import)
    end

    it 'should use default retries settings when they are not specified' do
      mock_result_import = double('mock_result_import')
      mock_result_exists = double('mock_result_exists')
      expect(mock_result_exists).to receive(:data).twice.and_return(true)
      expect(mock_result_exists).to receive(:message).and_return('Certificate chain exists')

      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::CertificateChain, 'import', anything).and_return(mock_result_import)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::CertificateChain, 'exists', anything).and_return(mock_result_exists)

      expect($stdout).to receive(:puts).with('Import check #1: true - Certificate chain exists')
      result = @certificate_chain.import_wait_until_ready('/somepath/cert_chain.crt', '/somepath/private_key.der')
      expect(result).to be(mock_result_import)
    end
  end
end
