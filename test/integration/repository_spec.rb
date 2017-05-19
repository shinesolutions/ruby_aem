require_relative 'spec_helper'

describe 'Repository' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test block repository writes' do
    it 'should succeed' do
      repository = @aem.repository
      result = repository.block_writes
      expect(result.message).to eq('Repository writes blocked')
    end
  end

  describe 'test unblock repository writes' do
    it 'should succeed' do
      repository = @aem.repository
      result = repository.unblock_writes
      expect(result.message).to eq('Repository writes unblocked')
    end
  end
end
