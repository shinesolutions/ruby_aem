require_relative 'spec_helper'
require_relative '../../lib/ruby_aem'

# Checks conf/spec.yaml against the installed swagger_aem / swagger_aem_osgi gems.
# The generated swagger clients silently ignore unknown opts keys, so a param name
# renamed by a swagger_aem regeneration (e.g. swagger_aem 4.0.0 renamed jcrcontent_*
# to jcr_content_*, operation to _operation, reppassword to rep_password) would
# otherwise only be noticed against a real AEM instance.
describe 'conf/spec.yaml' do
  before do
    @spec = YAML.load_file(File.expand_path('../../conf/spec.yaml', __dir__))
    @api_classes = {
      'console' => SwaggerAemClient::ConsoleApi,
      'configmgr' => SwaggerAemOsgiClient::ConfigmgrApi,
      'custom' => SwaggerAemClient::CustomApi,
      'cq' => SwaggerAemClient::CqApi,
      'crx' => SwaggerAemClient::CrxApi,
      'sling' => SwaggerAemClient::SlingApi,
      'granite' => SwaggerAemClient::GraniteApi
    }
    # Mismatches which pre-date swagger_aem 4.0.0 (already ignored with swagger_aem 3.8.0),
    # kept as-is to preserve existing behaviour until a decision is made on fixing them.
    @known_mismatches = {
      'aem.get_aem_health_check' => %w[combinetagsor],
      'package.create' => %w[charset],
      'package.update' => %w[charset],
      'configproperty.createapachefelixjettybasedhttpservice' => %w[org_apache_felix_https_truststore_key_type_hint json_maximumresults json_maximumresults_type_hint],
      'configproperty.createadobegranitesamlauthenticationhandler' => %w[digestMethod_type_hint]
    }
  end

  # Collect the opts keys read by a generated swagger client method, e.g. opts[:'jcr_content_cq_name'] .
  def swagger_opts_keys(method)
    file, line = method.source_location
    source = File.readlines(file)[(line - 1)..].join
    source = source[0..source.index("\n    end\n")]
    source.scan(/opts\[:'?(\w+)'?\]/).flatten.uniq
  end

  describe 'test params' do
    it 'should only use param names supported by the swagger client methods', :aggregate_failures do
      @spec.each { |resource_name, resource|
        resource['actions'].each { |action_name, action|
          api_class = @api_classes[action['api']]
          method = api_class.instance_method("#{RubyAem::Swagger.operation_to_method(action['operation'])}_with_http_info")

          required_params = action['params']['required'] || {}
          expect(required_params.size).to eq(method.parameters.count { |type, _| type == :req }), "#{resource_name}.#{action_name} required params count"

          optional_params = action['params']['optional'] || {}
          optional_keys = optional_params.is_a?(Hash) ? optional_params.keys : optional_params
          unsupported = optional_keys - swagger_opts_keys(method) - (@known_mismatches["#{resource_name}.#{action_name}"] || [])
          expect(unsupported).to eq([]), "#{resource_name}.#{action_name} optional params not supported by #{api_class}##{method.name}"
        }
      }
    end
  end

  describe 'test swagger client opts' do
    before do
      @mock_api = double('mock_api')
      @client = RubyAem::Client.new({ sling: @mock_api }, @spec)
    end

    it 'should pass jcr_content_* params when creating flush agent' do
      expect(@mock_api).to receive(:post_agent_with_http_info).once.with(
        'author',
        'some-flush-agent',
        {
          jcr_primary_type: 'cq:Page',
          jcr_content_cq_name: 'some-flush-agent',
          jcr_content_jcr_title: 'Some Flush Agent Title',
          jcr_content_jcr_description: 'Some flush agent description',
          jcr_content_sling_resource_type: 'cq/replication/components/agent',
          jcr_content_transport_uri: 'http://somehost:8080/dispatcher/invalidate.cache',
          jcr_content_alias_update: 'false',
          jcr_content_log_level: 'error',
          jcr_content_no_versioning: true,
          jcr_content_protocol_http_headers: ['CQ-Action:{action}', 'CQ-Handle:{path}', 'CQ-Path:{path}'],
          jcr_content_protocol_http_headers_type_hint: 'String[]',
          jcr_content_protocol_http_method: 'GET',
          jcr_content_retry_delay: '30000',
          jcr_content_serialization_type: 'flush',
          jcr_content_jcr_mixin_types: 'cq:ReplicationStatus',
          jcr_content_trigger_receive: true,
          jcr_content_trigger_specific: true,
          jcr_content_cq_template: '/libs/cq/replication/templates/agent',
          jcr_content_enabled: true,
          jcr_content_ssl: ''
        }
      ).and_return([nil, 201, {}])
      flush_agent = RubyAem::Resources::FlushAgent.new(@client, 'author', 'some-flush-agent')
      result = flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080')
      expect(result.message).to eq('Flush agent some-flush-agent created on author')
    end

    it 'should pass _operation param when deleting replication agent' do
      expect(@mock_api).to receive(:post_agent_with_http_info).once.with('author', 'some-replication-agent', { _operation: 'delete' }).and_return([nil, 204, {}])
      replication_agent = RubyAem::Resources::ReplicationAgent.new(@client, 'author', 'some-replication-agent')
      result = replication_agent.delete
      expect(result.message).to eq('Replication agent some-replication-agent deleted on author')
    end

    it 'should pass _operation param when creating truststore' do
      expect(@mock_api).to receive(:post_truststore_with_http_info).once.with({ new_password: 'somepassword', re_password: 'somepassword', _operation: 'createStore' }).and_return([nil, 200, {}])
      truststore = RubyAem::Resources::Truststore.new(@client)
      result = truststore.create('somepassword')
      expect(result.message).to eq('Truststore created')
    end

    it 'should pass rep_password param when creating user' do
      expect(@mock_api).to receive(:post_authorizables_with_http_info).once.with('someuser', '/home/users/s/', { create_user: 'true', rep_password: 'somepassword' }).and_return([nil, 201, {}])
      expect(RubyAem::Handlers).to receive(:html_authorizable_id).once
      user = RubyAem::Resources::User.new(@client, '/home/users/s/', 'someuser')
      user.create('somepassword')
    end
  end
end
