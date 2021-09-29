require_relative 'spec_helper'

describe 'Bundle' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test bundle stop' do
    it 'should succeed when bundle exists' do
      bundle = @aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.stop
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum stopped')
    end

    it 'should raise error when bundle does not exist' do
      bundle = @aem.bundle('someinexistingbundle')
      begin
        bundle.stop
        raise
      rescue RubyAem::Error => e
        expect(e.result.message).to eq('Bundle someinexistingbundle not found')
      end
    end
  end

  describe 'test bundle start' do
    it 'should succeed when bundle exists' do
      bundle = @aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.start
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum started')
    end

    it 'should raise error when bundle does not exist' do
      bundle = @aem.bundle('someinexistingbundle')
      begin
        bundle.start
      rescue RubyAem::Error => e
        expect(e.result.message).to eq('Bundle someinexistingbundle not found')
      end
    end
  end

  describe 'test bundle info' do
    it 'should return the bundle info when bundle is stopped' do
      bundle = @aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.stop
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum stopped')
      result = bundle.info
      expect(result.message).to eq('Retrieved bundle com.adobe.cq.social.cq-social-forum info')
      expect(result.data.data[0].state).to eq('Resolved')
    end
    it 'should return the bundle info when bundle is started' do
      bundle = @aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.start
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum started')
      result = bundle.info
      expect(result.message).to eq('Retrieved bundle com.adobe.cq.social.cq-social-forum info')
      expect(result.data.data[0].state).to eq('Active')
    end
  end

  describe 'test bundle is_active' do
    it 'should return false when bundle is stopped' do
      bundle = @aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.stop
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum stopped')
      result = bundle.is_active
      expect(result.data).to eq(false)
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum is not active. Bundle state is Resolved')
    end
    it 'should return true when bundle is started' do
      bundle = @aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.start
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum started')
      result = bundle.is_active
      expect(result.data).to eq(true)
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum is active')
    end
  end
end
