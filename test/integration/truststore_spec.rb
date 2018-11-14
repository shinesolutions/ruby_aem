require_relative 'spec_helper'

describe 'Truststore' do
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
  end

  after do
  end

  describe 'test truststore create' do
    it 'should return true on existence check' do
      result = @truststore.exists
      expect(result.message).to eq('Truststore exists')
      expect(result.data).to eq(true)
    end
  end

  describe 'test truststore delete' do
    it 'should succeed when truststore exists' do
      result = @truststore.delete
      expect(result.message).to eq('Truststore deleted')

      result = @truststore.exists
      expect(result.message).to eq('Truststore not found')
      expect(result.data).to eq(false)
    end

    it 'should raise error when truststore does not exist' do
      result = @truststore.delete
      expect(result.message).to eq('Truststore deleted')

      result = @truststore.exists
      expect(result.message).to eq('Truststore not found')
      expect(result.data).to eq(false)

      begin
        @truststore.delete
        raise
      rescue RubyAem::Error => err
        expect(err.result.message).to eq('Truststore not found')
      end
    end
  end

  describe 'test download upload' do
    it 'should succeed' do
      # download truststore
      result = @truststore.download('/tmp/truststore.p12')
      expect(result.message).to eq('Truststore downloaded to /tmp/truststore.p12')

      # upload truststore and wait until ready
      result = @truststore.upload_wait_until_ready('/tmp/truststore.p12', force: true)
      expect(result.message).to eq('Truststore uploaded')

      # force upload truststore
      result = @truststore.upload('/tmp/truststore.p12')
      expect(result.message).to eq('Truststore uploaded')
    end
  end
end
