require_relative 'spec_helper'

describe 'OutboxReplicationAgent' do
  before do
    @aem = init_client

    # ensure agent doesn't exist prior to testing
    @outbox_replication_agent = @aem.outbox_replication_agent('author', 'some-outbox-replication-agent')
    @outbox_replication_agent.delete if @outbox_replication_agent.exists.data == true
    result = @outbox_replication_agent.exists
    expect(result.data).to eq(false)

    # create agent
    result = @outbox_replication_agent.create_update('Some Outbox Replication Agent Title', 'Some outbox replication agent description', 'http://somehost:8080')
    expect(result.message).to eq('Outbox replication agent some-outbox-replication-agent created on author')
  end

  after do
  end

  describe 'test replication agent create update' do
    it 'should return true on existence check' do
      result = @outbox_replication_agent.exists
      expect(result.message).to eq('Outbox replication agent some-outbox-replication-agent exists on author')
      expect(result.data).to eq(true)
    end

    it 'should succeed update' do
      result = @outbox_replication_agent.create_update('Some Updated replication Agent Title', 'Some updated replication agent description', 'https://someotherhost:8081')
      expect(result.message).to eq('Outbox replication agent some-outbox-replication-agent updated on author')
    end
  end

  describe 'test replication agent delete' do
    it 'should succeed when replication agent exists' do
      result = @outbox_replication_agent.delete
      expect(result.message).to eq('Outbox replication agent some-outbox-replication-agent deleted on author')

      result = @outbox_replication_agent.exists
      expect(result.message).to eq('Outbox replication agent some-outbox-replication-agent not found on author')
      expect(result.data).to eq(false)
    end

    it 'should raise error when replication agent does not exist' do
      outbox_replication_agent = @aem.outbox_replication_agent('author', 'some-inexistingoutbox-replication-agent')
      begin
        outbox_replication_agent.delete
        raise
      rescue RubyAem::Error => err
        expect(err.result.message).to eq('Outbox replication agent some-inexistingoutbox-replication-agent not found on author')
      end
    end
  end
end
