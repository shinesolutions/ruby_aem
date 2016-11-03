require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/handlers/simple'

describe 'Simple Handler' do
  before do
  end

  after do
  end

  describe 'test simple' do

    it 'should construct result message based on spec message format and info parameters' do
      data = nil
      status_code = nil
      headers = nil
      response_spec = { 'status' => 'success', 'message' => 'Bundle %{name} started' }
      info = { :name => 'somebundle' }

      response = RubyAem::Response.new(status_code, data, headers)
      result = RubyAem::Handlers.simple(response, response_spec, info)
      expect(result.message).to eq('Bundle somebundle started')
      expect(result.response).to be(response)
    end

  end

end
