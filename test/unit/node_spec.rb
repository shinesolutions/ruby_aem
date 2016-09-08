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

end
