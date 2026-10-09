require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/ssl'

describe 'Ssl' do
  before do
    @mock_client = double('mock_client')
    @ssl = RubyAem::Resources::Ssl.new(@mock_client)
  end

  describe 'test enable' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Ssl,
        'enable',
        {
          keystore_password: 'password',
          keystore_passwordConfirm: 'password',
          truststore_password: 'password',
          truststore_passwordConfirm: 'password',
          https_hostname: 'localhost',
          https_port: 5432,
          file_path_private_key: './test/integration/fixtures/cert_ssl.der',
          file_path_certificate: './test/integration/fixtures/cert_ssl.crt'
        }
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

  describe 'test is_enabled' do
    it 'should return true result data when SSL port is set' do
      mock_response = mock_ssl_response(true, 5432)
      mock_result = double('mock_result')
      expect(mock_result).to receive(:response).and_return(mock_response)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Ssl, 'get', {}).and_return(mock_result)

      result = @ssl.is_enabled
      expect(result.message).to eq('HTTPS has been configured on port 5432')
      expect(result.response).to be(mock_response)
      expect(result.data).to eq(true)
    end

    it 'should return false result data when SSL port is not set' do
      mock_response = mock_ssl_response(false, nil)
      mock_result = double('mock_result')
      expect(mock_result).to receive(:response).and_return(mock_response)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Ssl, 'get', {}).and_return(mock_result)

      result = @ssl.is_enabled
      expect(result.message).to eq('HTTPS is not configured')
      expect(result.response).to be(mock_response)
      expect(result.data).to eq(false)
    end
  end

  describe 'test enable_wait_until_ready' do
    before do
      @opts = {
        keystore_password: 'password',
        truststore_password: 'password',
        https_hostname: 'localhost',
        https_port: 5432,
        certificate_file_path: './test/integration/fixtures/cert_ssl.crt',
        privatekey_file_path: './test/integration/fixtures/cert_ssl.der',
        _retries: {
          max_tries: '3',
          base_sleep_seconds: '0',
          max_sleep_seconds: '0'
        }
      }
    end

    it 'should return enable result when enabling SSL succeeds' do
      mock_result = double('mock_result')
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Ssl, 'enable', anything).and_return(mock_result)

      result = @ssl.enable_wait_until_ready(@opts)
      expect(result).to be(mock_result)
    end

    it 'should check until SSL is enabled when enabling SSL has response status code 0' do
      mock_response_error = double('mock_response_error')
      expect(mock_response_error).to receive(:status_code).and_return(0)
      mock_result_error = double('mock_result_error')
      expect(mock_result_error).to receive(:response).and_return(mock_response_error)
      mock_error = RubyAem::Error.new('Unexpected response', mock_result_error)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Ssl, 'enable', anything).and_raise(mock_error)

      mock_result_not_enabled = double('mock_result_not_enabled')
      expect(mock_result_not_enabled).to receive(:response).and_return(mock_ssl_response(false, nil))
      mock_result_enabled = double('mock_result_enabled')
      expect(mock_result_enabled).to receive(:response).and_return(mock_ssl_response(true, 5432))
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Ssl, 'get', anything).and_return(mock_result_not_enabled)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Ssl, 'get', anything).and_return(mock_result_enabled)

      expect($stdout).to receive(:puts).with('SSL Enable check #1: false - HTTPS is not configured')
      expect($stdout).to receive(:puts).with('SSL Enable check #2: true - HTTPS has been configured on port 5432')
      result = @ssl.enable_wait_until_ready(@opts)
      expect(result.message).to eq('HTTPS has been configured on port 5432')
      expect(result.data).to eq(true)
    end

    it 'should raise error when enabling SSL has response status code other than 0' do
      mock_response_error = double('mock_response_error')
      expect(mock_response_error).to receive(:status_code).and_return(500)
      mock_result_error = double('mock_result_error')
      expect(mock_result_error).to receive(:response).and_return(mock_response_error)
      mock_error = RubyAem::Error.new('Unexpected response', mock_result_error)
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Ssl, 'enable', anything).and_raise(mock_error)

      expect { @ssl.enable_wait_until_ready(@opts) }.to raise_error(StandardError)
    end

    it 'should use default retries settings when they are not specified' do
      mock_result = double('mock_result')
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::Ssl, 'enable', anything).and_return(mock_result)

      result = @ssl.enable_wait_until_ready
      expect(result).to be(mock_result)
    end
  end

  private

  def mock_ssl_response(is_set, value)
    mock_ssl_port = double('mock_ssl_port')
    allow(mock_ssl_port).to receive(:is_set).and_return(is_set)
    allow(mock_ssl_port).to receive(:value).and_return(value)
    mock_properties = double('mock_properties')
    allow(mock_properties).to receive(:com_adobe_granite_jetty_ssl_port).and_return(mock_ssl_port)
    mock_body = double('mock_body')
    allow(mock_body).to receive(:properties).and_return(mock_properties)
    mock_response = double('mock_response')
    allow(mock_response).to receive(:body).and_return(mock_body)
    mock_response
  end
end
