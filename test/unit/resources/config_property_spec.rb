require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/config_property'

describe 'ConfigProperty' do
  before do
    @mock_client = double('mock_client')
  end

  after do
  end

  describe 'test create' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ConfigProperty,
        'create',
        name: 'someproperty',
        config_node_name: 'org.apache.felix.http',
        type: 'Boolean',
        value: 'true',
        query_params: { 'someproperty' => 'true',
                        'someproperty@TypeHint' => 'Boolean' }
      )
      config_property = RubyAem::Resources::ConfigProperty.new(@mock_client, 'someproperty', 'Boolean', 'true')
      config_property.create('org.apache.felix.http')
    end
  end
end
