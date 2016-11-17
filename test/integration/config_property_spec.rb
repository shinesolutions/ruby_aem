require_relative 'spec_helper'

describe 'ConfigProperty' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test properties create SSL config' do

    it 'should fail when path node does not exist' do
      config_property = @aem.config_property('someinexistingnode', 'Boolean', true)
      begin
        config_property.create('author')
        fail
      rescue RubyAem::Error => err
        expect(err.message).to match(/^Unexpected response/)
      end
    end

  end

end
