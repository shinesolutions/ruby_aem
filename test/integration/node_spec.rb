require_relative 'spec_helper'

describe 'Node' do
  before do
    @aem = init_client

    # ensure node doesn't exist prior to testing
    @node = @aem.node('/apps/system/', 'somefolder')
    @node.delete()
  end

  after do
  end

  describe 'test node create' do

    it 'should succeed when node does not exist' do
      result = @node.create('sling:Folder')
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Node apps/system/somefolder created')
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

end
