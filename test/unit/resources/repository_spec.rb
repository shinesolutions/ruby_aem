require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/repository'

describe 'Repository' do
  before do
    @mock_client = double('mock_client')
    @repository = RubyAem::Resources::Repository.new(@mock_client)
  end

  after do
  end

  describe 'test block_writes' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Repository,
        'block_writes',
        {})
      @repository.block_writes
    end

  end

  describe 'test unblock_writes' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::Repository,
        'unblock_writes',
        {})
      @repository.unblock_writes
    end

  end

end
