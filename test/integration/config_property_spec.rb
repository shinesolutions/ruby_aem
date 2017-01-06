require_relative 'spec_helper'

describe 'ConfigProperty' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test properties create SSL config' do

    it 'should create a sling folder by default when path node does not exist' do
      config_property = @aem.config_property('someinexistingnode', 'Boolean', true)
      config_property.create('author')
    end

    it 'should create SSL property correctly when node exists' do

      # ensure node is created new
      node = @aem.node('/apps/system/config.author', 'org.apache.felix.http')
      if node.exists().data == true
        node.delete()
      end
      result = node.exists()
      expect(result.data).to eq(false)
      result = node.create('sling:OsgiConfig')

      config_property = @aem.config_property('org.apache.felix.https.enable', 'Boolean', true)
      config_property.create('author')
    end

  end

end