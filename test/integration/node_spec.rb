require_relative 'spec_helper'

describe 'Node' do
  before do
    @aem = init_client

    # ensure node doesn't exist prior to testing
    @node = @aem.node('/apps/system/', 'somefolder')
    @node.delete()
    result = @node.exists()
    expect(result.is_failure?).to be(true)
    expect(result.message).to eq('Node apps/system/somefolder not found')
  end

  after do
  end

  describe 'test node create' do

    it 'should succeed when node does not exist' do
      result = @node.create('sling:Folder')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder created')
    end

    it 'should raise error when node already exists' do

      result = @node.create('sling:Folder')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder created')

      # create the same node the second time
      begin
        @node.create('sling:Folder')
      rescue RubyAem::Error => err
        expect(err.message).to match(/^Unexpected response/)
      end
    end

    it 'should succeed existence check when node already exists' do
      # node does not exist
      result = @node.exists()
      expect(result.is_failure?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder not found')

      # create node
      result = @node.create('sling:Folder')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder created')

      # node should exist
      result = @node.exists()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder exists')
    end

  end

  describe 'test node delete' do

    it 'should succeed when node exists' do

      # ensure node exists prior to deletion
      result = @node.create('sling:Folder')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder created')

      result = @node.delete()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder deleted')
    end

  end

  describe 'test node exists' do

    it 'should succeed when node exists' do

      # ensure node exists prior to deletion
      result = @node.create('sling:Folder')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder created')

      result = @node.exists()
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder exists')
    end

  end

end
