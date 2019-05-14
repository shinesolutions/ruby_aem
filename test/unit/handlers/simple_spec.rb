require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/error'
require_relative '../../../lib/ruby_aem/handlers/simple'

describe 'Simple Handler' do
  before do
  end

  after do
  end

  describe 'test simple' do
    it 'should construct result message based on spec message format and call_params parameters' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Bundle %<name>s started' }
      call_params = { name: 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple(response, response_spec, call_params)
      expect(result.message).to eq('Bundle somebundle started')
      expect(result.response).to be(response)
    end
  end

  describe 'test simple_true' do
    it 'should construct result message with true data' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Bundle %<name>s started' }
      call_params = { name: 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple_true(response, response_spec, call_params)
      expect(result.message).to eq('Bundle somebundle started')
      expect(result.response).to be(response)
      expect(result.data).to be(true)
    end
  end

  describe 'test simple_false' do
    it 'should construct result message with false data' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Bundle %<name>s started' }
      call_params = { name: 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple_false(response, response_spec, call_params)
      expect(result.message).to eq('Bundle somebundle started')
      expect(result.response).to be(response)
      expect(result.data).to be(false)
    end
  end

  describe 'test simple_nil' do
    it 'should construct result message with false data' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Bundle %<name>s started' }
      call_params = { name: 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple_nil(response, response_spec, call_params)
      expect(result.message).to eq('Bundle somebundle started')
      expect(result.response).to be(response)
      expect(result.data).to be(nil)
    end
  end

  describe 'test simple_error' do
    it 'should raise error' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Bundle %<name>s started' }
      call_params = { name: 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      begin
        RubyAem::Handlers.simple_error(response, response_spec, call_params)
      rescue RubyAem::Error => e
        expect(e.result.message).to eq('Bundle somebundle started')
        expect(e.result.response).to be(response)
      end
    end
  end

  describe 'test simple_body' do
    it 'should construct result message with response body data' do
      data = 'some body'
      status_code = nil
      headers = nil
      response_spec = { 'message' => 'Some message' }
      call_params = {}

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple_body(response, response_spec, call_params)
      expect(result.message).to eq('Some message')
      expect(result.response).to be(response)
      expect(result.data).to eq('some body')
    end
  end
end
