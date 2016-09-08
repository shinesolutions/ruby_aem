require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/client'

describe 'Client' do
  before do
    @mock_client = double('mock_client')
  end

  after do
  end

  describe 'test create' do

    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once().with(
        RubyAem::ConfigProperty,
        'create',
        { :name => 'someproperty',
          :type => 'Boolean',
          :value => 'true',
          :run_mode => 'author',
          :someproperty => 'true',
          :someproperty_type_hint => 'Boolean' })
      config_property = RubyAem::ConfigProperty.new(@mock_client, 'someproperty', 'Boolean', 'true')
      config_property.create('author')
    end

  end

end
