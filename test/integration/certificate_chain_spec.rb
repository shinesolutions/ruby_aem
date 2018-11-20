require_relative 'spec_helper'

describe 'CertificateChain' do
  before do
    @aem = init_client

    # ensure authorizable keystore doesn't exist prior to testing
    @authorizable_keystore = @aem.authorizable_keystore('/home/users/system', 'authentication-service')
    @authorizable_keystore.delete unless @authorizable_keystore.exists.data == false
    result = @authorizable_keystore.exists
    expect(result.data).to eq(false)

    # create authorizable keystore
    result = @authorizable_keystore.create('s0m3p4ssw0rd')
    expect(result.message).to eq('Authorizable keystore created')

    # ensure certificate chain doesn't exist prior to testing
    @certificate_chain = @aem.certificate_chain('someprivatekeyalias', '/home/users/system', 'authentication-service')
    @certificate_chain.delete unless @certificate_chain.exists.data == false
    result = @certificate_chain.exists
    expect(result.data).to eq(false)

    # create certificate chain
    result = @certificate_chain.create('./test/integration/fixtures/cert_chain.crt', './test/integration/fixtures/private_key.der')
    expect(result.message).to eq('Certificate chain and private key successfully imported')
  end

  after do
  end

  describe 'test import' do
    it 'should return true on existence check' do
      result = @certificate_chain.import('./test/integration/fixtures/cert_chain.crt', './test/integration/fixtures/private_key.der')
      expect(result.message).to eq('Certificate chain and private key successfully imported')

      result = @certificate_chain.exists
      expect(result.message).to eq('Certificate chain exists')
      expect(result.data).to eq(true)
    end
  end

  describe 'test import wait until ready' do
    it 'should return true on existence check' do
      result = @certificate_chain.import_wait_until_ready('./test/integration/fixtures/cert_chain.crt', './test/integration/fixtures/private_key.der')
      expect(result.message).to eq('Certificate chain and private key successfully imported')

      result = @certificate_chain.exists
      expect(result.message).to eq('Certificate chain exists')
      expect(result.data).to eq(true)
    end
  end

  describe 'test delete' do
    it 'should succeed when certificate exists' do
      result = @certificate_chain.delete
      expect(result.message).to eq('Certificate chain deleted')

      result = @certificate_chain.exists
      expect(result.message).to eq('Certificate chain not found')
      expect(result.data).to eq(false)
    end

    it 'should raise error when certificate does not exist' do
      result = @certificate_chain.delete
      expect(result.message).to eq('Certificate chain deleted')

      result = @certificate_chain.exists
      expect(result.message).to eq('Certificate chain not found')
      expect(result.data).to eq(false)

      begin
        @certificate_chain.delete
        raise
      rescue RubyAem::Error => err
        expect(err.result.message).to eq('Certificate chain not found')
      end
    end
  end

  #
  # describe 'test import wait until ready' do
  #   it 'should return true on existence check' do
  #     result = @certificate.import_wait_until_ready('./test/integration/fixtures/cert_chain.crt')
  #     expect(result.message).to eq('Certificate imported')
  #
  #     result = @certificate.exists
  #     expect(result.message).to eq('Certificate exists')
  #     expect(result.data).to eq(true)
  #   end
  # end
  #
  # describe 'test import export' do
  #   it 'should be able to export the cert which was imported' do
  #     result = @certificate.import('./test/integration/fixtures/cert_chain.crt')
  #     expect(result.message).to eq('Certificate imported')
  #
  #     result = @certificate.exists
  #     expect(result.message).to eq('Certificate exists')
  #     expect(result.data).to eq(true)
  #
  #     result = @certificate.export('s0m3p4ssw0rd')
  #     expect(result.message).to eq('Certificate exported')
  #     expect(result.data.to_s.start_with?('-----BEGIN CERTIFICATE-----')).to be(true)
  #   end
  # end
  #
  # describe 'test delete' do
  #   it 'should succeed when certificate exists' do
  #     result = @certificate.delete
  #     expect(result.message).to eq('Certificate 15863505968020663268 deleted')
  #
  #     result = @certificate.exists
  #     expect(result.message).to eq('Certificate not found')
  #     expect(result.data).to eq(false)
  #   end
  #
  #   it 'should raise error when certificate does not exist' do
  #     result = @certificate.delete
  #     expect(result.message).to eq('Certificate 15863505968020663268 deleted')
  #
  #     result = @certificate.exists
  #     expect(result.message).to eq('Certificate not found')
  #     expect(result.data).to eq(false)
  #
  #     begin
  #       @certificate.delete
  #       raise
  #     rescue RubyAem::Error => err
  #       expect(err.result.message).to eq('Certificate not found')
  #     end
  #   end
  # end
end
