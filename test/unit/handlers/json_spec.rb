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
      response_spec = { 'message' => 'Found user %{name} authorizable ID %{authorizable_id}' }
      call_params = { :name => 'someuser' }

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
      response_spec = { 'message' => 'Found user %{name} authorizable ID %{authorizable_id}' }
      call_params = { :name => 'someuser' }

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
        fail
      rescue RubyAem::Error => err
        expect(err.message).to eq('Package built')
        expect(err.result.response).to eq(response)
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

end
