require_relative 'spec_helper'

describe 'ReplicationAgent' do
  before do
    @aem = init_client

    # ensure agent doesn't exist prior to testing
    @replication_agent = @aem.replication_agent('author', 'some-replication-agent')
    result = @replication_agent.delete()

    # create agent
    result = @replication_agent.create_update('Some replication Agent Title', 'Some replication agent description', 'http://somehost:8080')
    expect(result.is_success?).to be(true)
    expect(result.message).to eq('Replication agent some-replication-agent created on author')
  end

  after do
  end

  describe 'test replication agent create update' do

    it 'should succeed existence check' do
      result = @replication_agent.exists()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Replication agent some-replication-agent exists on author')
    end

    it 'should succeed update' do
      result = @replication_agent.create_update('Some Updated replication Agent Title', 'Some updated replication agent description', 'https://someotherhost:8081')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Replication agent some-replication-agent updated on author')
    end

  end

  describe 'test replication agent delete' do

    it 'should succeed existence check' do
      result = @replication_agent.delete()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Replication agent some-replication-agent deleted on author')

      result = @replication_agent.exists()
      expect(result.is_failure?).to be(true)
      expect(result.message).to eq('Replication agent some-replication-agent not found on author')
    end

  end

end
