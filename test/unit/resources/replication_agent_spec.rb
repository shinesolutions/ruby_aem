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

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::ReplicationAgent,
        'create_update',
        { :run_mode => 'author',
          :name => 'some-replication-agent',
          :title => 'Some replication Agent Title',
          :description => 'Some replication agent description',
          :dest_base_url => 'http://somehost:8080' })
      @replication_agent.create_update('Some replication Agent Title', 'Some replication agent description', 'http://somehost:8080')
    end

  end

  describe 'test delete' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::ReplicationAgent,
        'delete',
        { :run_mode => 'author',
          :name => 'some-replication-agent' })
      @replication_agent.delete
    end

  end

  describe 'test exists' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Resources::ReplicationAgent,
        'exists',
        { :run_mode => 'author',
          :name => 'some-replication-agent' })
      @replication_agent.exists
    end

  end

end
