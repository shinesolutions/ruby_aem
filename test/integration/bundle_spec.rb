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
      expect(result.is_success?).to be(true)
    end

    it 'should fail when bundle does not exist' do
      bundle = @aem.bundle('someinexistingbundle')
      result = bundle.stop()
      expect(result.is_failure?).to be(true)
    end

  end

  describe 'test bundle start' do

    it 'should succeed when bundle exists' do
      bundle = @aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.start()
      expect(result.is_success?).to be(true)
    end

    it 'should fail when bundle does not exist' do
      bundle = @aem.bundle('someinexistingbundle')
      result = bundle.start()
      expect(result.is_failure?).to be(true)
    end

  end

end
