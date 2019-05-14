require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/handlers/json'

describe 'JSON Handler' do
  before do
  end

  after do
  end

  describe 'test json_authorizable_id' do
    it 'should return success result when authorizable ID is found' do
      data = '{"success":true,"results":1,"total":1,"more":false,"offset":0,"hits":[{"path":"/home/groups/s/cnf6J9EF5WtGm9X6CZT4","excerpt":"","name":"cnf6J9EF5WtGm9X6CZT4","title":"cnf6J9EF5WtGm9X6CZT4","lastModified":"2016-09-12 21:13:07","created":"2016-09-12 21:13:07"}]}'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Found user %<name>s authorizable ID %<authorizable_id>s' }
      call_params = { name: 'someuser' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_authorizable_id(response, response_spec, call_params)
      expect(result.message).to eq('Found user someuser authorizable ID cnf6J9EF5WtGm9X6CZT4')
      expect(result.response).to be(response)
      expect(result.data).to eq('cnf6J9EF5WtGm9X6CZT4')
    end

    it 'should return failure result when authorizable ID is not found' do
      data = '{"success":false,"results":0,"total":0,"more":false,"offset":0,"hits":[]}'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Found user %<name>s authorizable ID %<authorizable_id>s' }
      call_params = { name: 'someuser' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_authorizable_id(response, response_spec, call_params)
      expect(result.message).to eq('User/Group someuser authorizable ID not found')
      expect(result.response).to be(response)
      expect(result.data).to eq(nil)
    end
  end

  describe 'test json_package_service' do
    it 'should return result with status and message from data payload' do
      data = '{ "success": true, "msg": "Package built" }'
      status_code = nil
      headers = nil
      response_spec = nil
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_package_service(response, response_spec, call_params)
      expect(result.message).to eq('Package built')
      expect(result.response).to eq(response)
    end

    it 'should raise error when payload is not a success' do
      data = '{ "success": false, "msg": "Package built" }'
      status_code = nil
      headers = nil
      response_spec = nil
      call_params = {}

      begin
        response = RubyAem::Response.new(status_code, data, headers)
        RubyAem::Handlers.json_package_service(response, response_spec, call_params)
        raise
      rescue RubyAem::Error => e
        expect(e.message).to eq('Package built')
        expect(e.result.response).to eq(response)
      end
    end
  end

  describe 'test json_package_filter' do
    it 'should return success result with filter data payload' do
      data =
        '{' \
        '  "jcr:primaryType": "nt:unstructured",' \
        '  "f0": {' \
        '    "jcr:primaryType": "nt:unstructured",' \
        '    "mode": "replace",' \
        '    "root": "/apps/geometrixx",' \
        '    "rules": []' \
        '  },' \
        '  "f1": {' \
        '    "jcr:primaryType": "nt:unstructured",' \
        '    "mode": "replace",' \
        '    "root": "/apps/geometrixx-common",' \
        '    "rules": []' \
        '  }' \
        '}'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Filter retrieved successfully' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_package_filter(response, response_spec, call_params)
      expect(result.message).to eq('Filter retrieved successfully')
      expect(result.response).to eq(response)
      expect(result.data.length).to eq(2)
      expect(result.data[0]).to eq('/apps/geometrixx')
      expect(result.data[1]).to eq('/apps/geometrixx-common')
    end
  end

  describe 'test json_aem_health_check' do
    it 'should return success result with filter data payload' do
      data =
        '{' \
        '  "results": [' \
        '    {' \
        '      "name": "name1",' \
        '      "status": "OK",' \
        '      "timeMs": 11' \
        '    },' \
        '    {' \
        '      "name": "name2",' \
        '      "status": "CRITICAL",' \
        '      "timeMs": 22' \
        '    }' \
        '  ]' \
        '}'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'AEM Health Check retrieved successfully' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_aem_health_check(response, response_spec, call_params)
      expect(result.message).to eq('AEM Health Check retrieved successfully')
      expect(result.response).to eq(response)
      expect(result.data.length).to eq(2)
      expect(result.data[0]['name']).to eq('name1')
      expect(result.data[0]['status']).to eq('OK')
      expect(result.data[1]['name']).to eq('name2')
      expect(result.data[1]['status']).to eq('CRITICAL')
    end
  end

  describe 'test json_agents' do
    it 'should return agent names' do
      data =
        '{' \
        '  "jcr:primaryType": "cq:Page",' \
        '  "rep:policy": "",' \
        '  "agent1": {},' \
        '  "agent2": {}' \
        '}'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Retrieved agents on %<run_mode>s' }
      call_params = { run_mode: 'author' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_agents(response, response_spec, call_params)
      expect(result.message).to eq('Retrieved agents on author')
      expect(result.response).to eq(response)
      expect(result.data.length).to eq(2)
      expect(result.data[0]).to eq('agent1')
      expect(result.data[1]).to eq('agent2')
    end
  end

  describe 'test json_truststore_exists' do
    it 'should construct result message with true data when the payload contains aliases' do
      data = SwaggerAemClient::TruststoreInfo.new
      data.aliases = []
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Truststore exists' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_truststore_exists(response, response_spec, call_params)
      expect(result.data).to be(true)
      expect(result.message).to eq('Truststore exists')
      expect(result.response).to be(response)
    end
    it 'should construct result message with false data when the expected message does not exist' do
      data = SwaggerAemClient::TruststoreInfo.new
      data.exists = false
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Truststore not found' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_truststore_exists(response, response_spec, call_params)
      expect(result.data).to be(false)
      expect(result.message).to eq('Truststore not found')
      expect(result.response).to be(response)
    end
  end

  describe 'test json_authorizable_keystore_exists' do
    it 'should construct result message with true data when the payload contains aliases' do
      data = SwaggerAemClient::KeystoreInfo.new
      data.aliases = []
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Authorizable keystore exists' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_truststore_exists(response, response_spec, call_params)
      expect(result.data).to be(true)
      expect(result.message).to eq('Authorizable keystore exists')
      expect(result.response).to be(response)
    end
    it 'should construct result message with false data when the expected message does not exist' do
      data = SwaggerAemClient::KeystoreInfo.new
      data.exists = false
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Authorizable keystore not found' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.json_authorizable_keystore_exists(response, response_spec, call_params)
      expect(result.data).to be(false)
      expect(result.message).to eq('Authorizable keystore not found')
      expect(result.response).to be(response)
    end
  end
end
