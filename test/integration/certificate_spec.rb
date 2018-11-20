require_relative 'spec_helper'

describe 'Certificate' do
  before do
    @aem = init_client

    # ensure truststore doesn't exist prior to testing
    @truststore = @aem.truststore
    @truststore.delete unless @truststore.exists.data == false
    result = @truststore.exists
    expect(result.data).to eq(false)

    # create truststore
    result = @truststore.create('s0m3p4ssw0rd')
    expect(result.message).to eq('Truststore created')

    # ensure certificate doesn't exist prior to testing
    # the serial number here matches the example cert file at `./test/integration/fixtures/cert_chain.crt`
    @certificate = @aem.certificate('15863505968020663268')
    @certificate.delete unless @certificate.exists.data == false
    result = @certificate.exists
    expect(result.data).to eq(false)

    # create certificate
    result = @certificate.create('./test/integration/fixtures/cert_chain.crt')
    expect(result.message).to eq('Certificate imported')
  end

  after do
  end

  describe 'test import' do
    it 'should return true on existence check' do
      result = @certificate.import('./test/integration/fixtures/cert_chain.crt')
      expect(result.message).to eq('Certificate imported')

      result = @certificate.exists
      expect(result.message).to eq('Certificate exists')
      expect(result.data).to eq(true)
    end
  end

  describe 'test import wait until ready' do
    it 'should return true on existence check' do
      result = @certificate.import_wait_until_ready('./test/integration/fixtures/cert_chain.crt')
      expect(result.message).to eq('Certificate imported')

      result = @certificate.exists
      expect(result.message).to eq('Certificate exists')
      expect(result.data).to eq(true)
    end
  end

  describe 'test import export' do
    it 'should be able to export the cert which was imported' do
      result = @certificate.import('./test/integration/fixtures/cert_chain.crt')
      expect(result.message).to eq('Certificate imported')

      result = @certificate.exists
      expect(result.message).to eq('Certificate exists')
      expect(result.data).to eq(true)

      result = @certificate.export('s0m3p4ssw0rd')
      expect(result.message).to eq('Certificate exported')
      expect(result.data.to_s.start_with?('-----BEGIN CERTIFICATE-----')).to be(true)
    end
  end

  describe 'test delete' do
    it 'should succeed when certificate exists' do
      result = @certificate.delete
      expect(result.message).to eq('Certificate 15863505968020663268 deleted')

      result = @certificate.exists
      expect(result.message).to eq('Certificate not found')
      expect(result.data).to eq(false)
    end

    it 'should raise error when certificate does not exist' do
      result = @certificate.delete
      expect(result.message).to eq('Certificate 15863505968020663268 deleted')

      result = @certificate.exists
      expect(result.message).to eq('Certificate not found')
      expect(result.data).to eq(false)

      begin
        @certificate.delete
        raise
      rescue RubyAem::Error => err
        expect(err.result.message).to eq('Certificate not found')
      end
    end
  end
end
