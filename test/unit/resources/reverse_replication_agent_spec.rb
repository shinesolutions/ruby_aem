require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/reverse_replication_agent'

describe 'ReverseReplicationAgent' do
  before do
    @mock_client = double('mock_client')
    @reverse_replication_agent = RubyAem::Resources::ReverseReplicationAgent.new(@mock_client, 'author', 'some-reverse-replication-agent')
  end

  after do
  end

  describe 'test create_update' do
    it 'should call client with expected parameters having default optional parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ReverseReplicationAgent,
        'create_update',
        run_mode: 'author',
        name: 'some-reverse-replication-agent',
        title: 'Some Reverse Replication Agent Title',
        description: 'Some reverse replication agent description',
        dest_base_url: 'http://somehost:8080',
        transport_user: 'admin',
        transport_password: 'admin',
        log_level: 'error',
        retry_delay: 30000
      )
      @reverse_replication_agent.create_update('Some Reverse Replication Agent Title', 'Some reverse replication agent description', 'http://somehost:8080')
    end

    it 'should call client with expected parameters having custom optional parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ReverseReplicationAgent,
        'create_update',
        run_mode: 'author',
        name: 'some-reverse-replication-agent',
        title: 'Some Reverse Replication Agent Title',
        description: 'Some reverse replication agent description',
        dest_base_url: 'http://somehost:8080',
        transport_user: 'someuser',
        transport_password: 'somepassword',
        log_level: 'info',
        retry_delay: 60000
      )
      @reverse_replication_agent.create_update(
        'Some Reverse Replication Agent Title',
        'Some reverse replication agent description',
        'http://somehost:8080',
        transport_user: 'someuser',
        transport_password: 'somepassword',
        log_level: 'info',
        retry_delay: 60000
      )
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ReverseReplicationAgent,
        'delete',
        run_mode: 'author',
        name: 'some-reverse-replication-agent'
      )
      @reverse_replication_agent.delete
    end
  end

  describe 'test exists' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ReverseReplicationAgent,
        'exists',
        run_mode: 'author',
        name: 'some-reverse-replication-agent'
      )
      @reverse_replication_agent.exists
    end
  end
end
