require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/ssl'

describe 'Ssl' do
  before do
    @mock_client = double('mock_client')
    @ssl = RubyAem::Resources::Ssl.new(@mock_client)
  end

  after do
  end

  describe 'test enable' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Ssl,
        'enable',
        keystore_password: 'password',
        keystore_passwordConfirm: 'password',
        truststore_password: 'password',
        truststore_passwordConfirm: 'password',
        https_hostname: 'localhost',
        https_port: 5432,
        file_path_private_key: './test/integration/fixtures/cert_ssl.der',
        file_path_certificate: './test/integration/fixtures/cert_ssl.crt'
      )
      opts = {
        keystore_password: 'password',
        truststore_password: 'password',
        https_hostname: 'localhost',
        https_port: 5432,
        certificate_file_path: './test/integration/fixtures/cert_ssl.crt',
        privatekey_file_path: './test/integration/fixtures/cert_ssl.der'
      }
      @ssl.enable(opts)
    end
  end

  describe 'test get' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Ssl,
        'get',
        {}
      )
      @ssl.get
    end
  end

  describe 'test disable' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Ssl,
        'disable',
        {}
      )
      @ssl.disable
    end
  end
end
