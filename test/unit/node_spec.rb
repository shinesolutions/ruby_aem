require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/node'

describe 'Node' do
  before do
    @mock_client = double('mock_client')
    @node = RubyAem::Node.new(@mock_client, '/apps/system/', 'somefolder')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Node,
        'create',
        { :path => 'apps/system',
          :name => 'somefolder',
          :type => 'sling:Folder' })
      @node.create('sling:Folder')
    end

  end

  describe 'test delete' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Node,
        'delete',
        { :path => 'apps/system',
          :name => 'somefolder' })
      @node.delete()
    end

  end

  describe 'test exists' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::Node,
        'exists',
        { :path => 'apps/system',
          :name => 'somefolder' })
      @node.exists()
    end

  end

end
