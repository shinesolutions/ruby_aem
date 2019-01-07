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
        'createapachefelixjettybasedhttpservice',
        name: 'someproperty',
        config_node_name: 'org.apache.felix.http',
        type: 'Boolean',
        value: 'true',
        someproperty: 'true',
        someproperty_type_hint: 'Boolean'
      )
      config_property = RubyAem::Resources::ConfigProperty.new(@mock_client, 'someproperty', 'Boolean', 'true')
      config_property.create('org.apache.felix.http')
    end

    it 'should call client with expected parameters when property is a keyword' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ConfigProperty,
        'createapacheslingdavexservlet',
        name: 'alias',
        config_node_name: 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet',
        type: 'String',
        value: '/crx/server',
        _alias: '/crx/server',
        alias_type_hint: 'String'
      )
      config_property = RubyAem::Resources::ConfigProperty.new(@mock_client, 'alias', 'String', '/crx/server')
      config_property.create('org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet')
    end

    it 'should call client with expected parameters when property is a keyword for org.apache.http.proxyconfigurator.config' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::ConfigProperty,
        'createapachehttpcomponentsproxyconfiguration',
        name: 'proxy_host',
        config_node_name: 'org.apache.http.proxyconfigurator.config',
        type: 'String',
        value: '192.168.1.1',
        proxy_host: '192.168.1.1',
        proxy_host_type_hint: 'String'
      )
      config_property = RubyAem::Resources::ConfigProperty.new(@mock_client, 'proxy_host', 'String', '192.168.1.1')
      config_property.create('org.apache.http.proxyconfigurator.config')
    end
  end
end
