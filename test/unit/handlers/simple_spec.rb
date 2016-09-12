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
      
      result = RubyAem::Handlers.simple(data, status_code, headers, response_spec, info)
      expect(result.is_success?).to be(true)
      expect(result.message).to eq('Bundle somebundle started')
    end

  end

end
