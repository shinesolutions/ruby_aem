require_relative 'spec_helper'

describe 'Ssl' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test if SSL via granite is disabled' do
    it 'should verify HTTPS is disabled' do
      ssl = @aem.ssl

      result = ssl.is_enabled
      expect(result.message).to eq('HTTPS is not configured')
      expect(result.response.status_code).to eq(200)
    end
  end

  describe 'test enabling SSL via granite' do
    it 'should successfully enable SSL' do
      ssl = @aem.ssl
      opts = {
        keystore_password: 'password',
        truststore_password: 'password',
        https_hostname: 'localhost',
        https_port: 5432,
        certificate_file_path: './test/integration/fixtures/cert_ssl.crt',
        privatekey_file_path: './test/integration/fixtures/cert_ssl.der'
      }
      result = ssl.enable_wait_until_ready(opts)
      expect(result.message).to eq('HTTPS has been configured on port 5432')
      expect(result.response.status_code).to eq(200)
    end
  end

  describe 'test retrieve granite SSL settings' do
    it 'should successfully retrieve the granite SSL settings' do
      ssl = @aem.ssl

      result = ssl.get
      expect(result.message).to eq('HTTPS Configuration found')
      expect(result.response.status_code).to eq(200)
    end
  end

  describe 'test if SSL via granite is enabled' do
    it 'should verify HTTPS is enabled' do
      ssl = @aem.ssl

      result = ssl.is_enabled
      expect(result.message).to eq('HTTPS has been configured on port 5432')
      expect(result.response.status_code).to eq(200)
    end
  end

  describe 'test disabling SSL via Granite' do
    it 'should successfully disable SSL' do
      ssl = @aem.ssl

      result = ssl.disable
      expect(result.message).to eq('HTTPS has been disabled')
      expect(result.response.status_code).to eq(200)
    end
  end
end
