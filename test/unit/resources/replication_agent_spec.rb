require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/replication_agent'

describe 'ReplicationAgent' do
  before do
    @mock_client = double('mock_client')
    @replication_agent = RubyAem::Resources::ReplicationAgent.new(@mock_client, 'author', 'some-replication-agent')
  end

  after do
  end

  describe 'test create_update' do
    it 'should call client with expected parameters having default optional parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ReplicationAgent,
        'create_update',
        run_mode: 'author',
        name: 'some-replication-agent',
        title: 'Some replication Agent Title',
        description: 'Some replication agent description',
        dest_base_url: 'http://somehost:8080',
        transport_user: 'admin',
        transport_password: 'admin',
        log_level: 'error',
        retry_delay: 30000
      )
      @replication_agent.create_update('Some replication Agent Title', 'Some replication agent description', 'http://somehost:8080')
    end

    it 'should call client with expected parameters having custom optional parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ReplicationAgent,
        'create_update',
        run_mode: 'author',
        name: 'some-replication-agent',
        title: 'Some replication Agent Title',
        description: 'Some replication agent description',
        dest_base_url: 'http://somehost:8080',
        transport_user: 'someuser',
        transport_password: 'somepassword',
        log_level: 'info',
        retry_delay: 60000
      )
      @replication_agent.create_update('Some replication Agent Title', 'Some replication agent description', 'http://somehost:8080', transport_user: 'someuser', transport_password: 'somepassword', log_level: 'info', retry_delay: 60000)
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ReplicationAgent,
        'delete',
        run_mode: 'author',
        name: 'some-replication-agent'
      )
      @replication_agent.delete
    end
  end

  describe 'test exists' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ReplicationAgent,
        'exists',
        run_mode: 'author',
        name: 'some-replication-agent'
      )
      @replication_agent.exists
    end
  end
end
