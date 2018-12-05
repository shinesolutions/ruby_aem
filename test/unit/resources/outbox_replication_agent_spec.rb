require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/outbox_replication_agent'

describe 'OutboxReplicationAgent' do
  before do
    @mock_client = double('mock_client')
    @outbox_replication_agent = RubyAem::Resources::OutboxReplicationAgent.new(@mock_client, 'author', 'some-outbox-replication-agent')
  end

  after do
  end

  describe 'test create_update' do
    it 'should call client with expected parameters having default optional parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::OutboxReplicationAgent,
        'create_update',
        run_mode: 'author',
        name: 'some-outbox-replication-agent',
        title: 'Some Outbox Replication Agent Title',
        description: 'Some outbox replication agent description',
        dest_base_url: 'http://somehost:8080',
        user_id: 'admin',
        log_level: 'error',
        retry_delay: 30000
      )
      @outbox_replication_agent.create_update('Some Outbox Replication Agent Title', 'Some outbox replication agent description', 'http://somehost:8080')
    end

    it 'should call client with expected parameters having custom optional parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::OutboxReplicationAgent,
        'create_update',
        run_mode: 'author',
        name: 'some-outbox-replication-agent',
        title: 'Some Outbox Replication Agent Title',
        description: 'Some outbox replication agent description',
        dest_base_url: 'http://somehost:8080',
        user_id: 'someuser',
        log_level: 'info',
        retry_delay: 60000
      )
      @outbox_replication_agent.create_update('Some Outbox Replication Agent Title', 'Some outbox replication agent description', 'http://somehost:8080', user_id: 'someuser', log_level: 'info', retry_delay: 60000)
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::OutboxReplicationAgent,
        'delete',
        run_mode: 'author',
        name: 'some-outbox-replication-agent'
      )
      @outbox_replication_agent.delete
    end
  end

  describe 'test exists' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::OutboxReplicationAgent,
        'exists',
        run_mode: 'author',
        name: 'some-outbox-replication-agent'
      )
      @outbox_replication_agent.exists
    end
  end
end
