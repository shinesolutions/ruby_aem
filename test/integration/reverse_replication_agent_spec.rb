require_relative 'spec_helper'

describe 'ReverseReplicationAgent' do
  before do
    @aem = init_client

    # ensure agent doesn't exist prior to testing
    @reverse_replication_agent = @aem.reverse_replication_agent('author', 'some-reverse-replication-agent')
    if @reverse_replication_agent.exists.data == true
      @reverse_replication_agent.delete
    end
    result = @reverse_replication_agent.exists
    expect(result.data).to eq(false)

    # create agent
    result = @reverse_replication_agent.create_update('Some Reverse Replication Agent Title', 'Some reverse replication agent description', 'http://somehost:8080')
    expect(result.message).to eq('Reverse replication agent some-reverse-replication-agent created on author')
  end

  after do
  end

  describe 'test replication agent create update' do
    it 'should return true on existence check' do
      result = @reverse_replication_agent.exists
      expect(result.message).to eq('Reverse replication agent some-reverse-replication-agent exists on author')
      expect(result.data).to eq(true)
    end

    it 'should succeed update' do
      result = @reverse_replication_agent.create_update('Some Updated replication Agent Title', 'Some updated replication agent description', 'https://someotherhost:8081')
      expect(result.message).to eq('Reverse replication agent some-reverse-replication-agent updated on author')
    end
  end

  describe 'test replication agent delete' do
    it 'should succeed when replication agent exists' do
      result = @reverse_replication_agent.delete
      expect(result.message).to eq('Reverse replication agent some-reverse-replication-agent deleted on author')

      result = @reverse_replication_agent.exists
      expect(result.message).to eq('Reverse replication agent some-reverse-replication-agent not found on author')
      expect(result.data).to eq(false)
    end

    it 'should raise error when replication agent does not exist' do
      reverse_replication_agent = @aem.reverse_replication_agent('author', 'some-inexistingreverse-replication-agent')
      begin
        reverse_replication_agent.delete
        raise
      rescue RubyAem::Error => err
        expect(err.result.message).to eq('Reverse replication agent some-inexistingreverse-replication-agent not found on author')
      end
    end
  end
end
