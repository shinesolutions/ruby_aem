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

  end

end
