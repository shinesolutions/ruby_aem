require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/flush_agent'

describe 'FlushAgent' do
  before do
    @mock_client = double('mock_client')
    @flush_agent = RubyAem::FlushAgent.new(@mock_client, 'author', 'some-flush-agent')
  end

  after do
  end

  describe 'test create_update' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::FlushAgent,
        'create_update',
        { :run_mode => 'author',
          :name => 'some-flush-agent',
          :title => 'Some Flush Agent Title',
          :description => 'Some flush agent description',
          :dest_base_url => 'http://somehost:8080' })
      @flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080')
    end

  end

  describe 'test delete' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::FlushAgent,
        'delete',
        { :run_mode => 'author',
          :name => 'some-flush-agent' })
      @flush_agent.delete
    end

  end

  describe 'test exists' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::FlushAgent,
        'exists',
        { :run_mode => 'author',
          :name => 'some-flush-agent' })
      @flush_agent.exists
    end

  end

end
