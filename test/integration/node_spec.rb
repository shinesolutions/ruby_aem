require_relative 'spec_helper'

describe 'Node' do
  before do
    @aem = init_client

    # ensure node doesn't exist prior to testing
    @node = @aem.node('/apps/system/', 'somefolder')
    @node.delete unless @node.exists.data == false
    result = @node.exists
    expect(result.data).to eq(false)
  end

  after do
  end

  describe 'test node create' do
    it 'should succeed when node does not yet exist' do
      result = @node.create('sling:Folder')
      expect(result.message).to eq('Node apps/system/somefolder created')
      result = @node.exists
      expect(result.data).to eq(true)
    end

    it 'should raise error when node already exists' do
      result = @node.create('sling:Folder')
      expect(result.message).to eq('Node apps/system/somefolder created')
      result = @node.exists
      expect(result.data).to eq(true)

      # create the same node the second time
      begin
        @node.create('sling:Folder')
      rescue RubyAem::Error => err
        expect(err.message).to match(/^Unexpected response/)
      end
    end

    it 'should succeed existence check when node already exists' do
      # node does not exist
      result = @node.exists
      expect(result.message).to eq('Node apps/system/somefolder not found')
      expect(result.data).to eq(false)

      # create node
      result = @node.create('sling:Folder')
      expect(result.message).to eq('Node apps/system/somefolder created')

      # node should exist
      result = @node.exists
      expect(result.message).to eq('Node apps/system/somefolder exists')
      expect(result.data).to eq(true)
    end
  end

  describe 'test node delete' do
    it 'should succeed when node exists' do
      # ensure node exists prior to deletion
      result = @node.create('sling:Folder')
      expect(result.message).to eq('Node apps/system/somefolder created')
      result = @node.exists
      expect(result.data).to eq(true)

      result = @node.delete
      expect(result.message).to eq('Node apps/system/somefolder deleted')
      result = @node.exists
      expect(result.data).to eq(false)
    end

    it 'should raise error when node does not exist' do
      # ensure node doesn't exist
      result = @node.exists
      expect(result.data).to eq(false)

      begin
        @node.delete
      rescue RubyAem::Error => err
        expect(err.result.message).to eq('Node apps/system/somefolder not found')
      end
    end
  end

  describe 'test node exists' do
    it 'should be true when node exists' do
      result = @node.create('sling:Folder')
      expect(result.message).to eq('Node apps/system/somefolder created')

      result = @node.exists
      expect(result.message).to eq('Node apps/system/somefolder exists')
      expect(result.data).to eq(true)
    end

    it 'should be false when node does not exist' do
      result = @node.exists
      expect(result.message).to eq('Node apps/system/somefolder not found')
      expect(result.data).to eq(false)
    end
  end
end
