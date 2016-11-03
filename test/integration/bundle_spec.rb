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
      result = bundle.stop()
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum stopped')
    end

    it 'should fail when bundle does not exist' do
      bundle = @aem.bundle('someinexistingbundle')
      result = bundle.stop()
      expect(result.message).to eq('Bundle someinexistingbundle not found')
    end

  end

  describe 'test bundle start' do

    it 'should succeed when bundle exists' do
      bundle = @aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.start()
      expect(result.message).to eq('Bundle com.adobe.cq.social.cq-social-forum started')
    end

    it 'should fail when bundle does not exist' do
      bundle = @aem.bundle('someinexistingbundle')
      result = bundle.start()
      expect(result.message).to eq('Bundle someinexistingbundle not found')
    end

  end

end
