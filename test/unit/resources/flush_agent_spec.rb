require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/flush_agent'

describe 'FlushAgent' do
  before do
    @mock_client = double('mock_client')
    @flush_agent = RubyAem::Resources::FlushAgent.new(@mock_client, 'author', 'some-flush-agent')
  end

  after do
  end

  describe 'test create_update' do
    it 'should call client with expected parameters having default optional parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::FlushAgent,
        'create_update',
        run_mode: 'author',
        name: 'some-flush-agent',
        title: 'Some Flush Agent Title',
        description: 'Some flush agent description',
        dest_base_url: 'http://somehost:8080',
        ssl: '',
        log_level: 'error',
        retry_delay: 30_000
      )
      @flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080')
    end

    it 'should call client with expected parameters having custom optional parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::FlushAgent,
        'create_update',
        run_mode: 'author',
        name: 'some-flush-agent',
        title: 'Some Flush Agent Title',
        description: 'Some flush agent description',
        dest_base_url: 'https://somehost:8080',
        ssl: 'relaxed',
        log_level: 'info',
        retry_delay: 60_000
      )
      @flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'https://somehost:8080', log_level: 'info', retry_delay: 60_000)
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::FlushAgent,
        'delete',
        run_mode: 'author',
        name: 'some-flush-agent'
      )
      @flush_agent.delete
    end
  end

  describe 'test exists' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::FlushAgent,
        'exists',
        run_mode: 'author',
        name: 'some-flush-agent'
      )
      @flush_agent.exists
    end
  end
end
