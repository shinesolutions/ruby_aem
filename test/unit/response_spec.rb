require_relative 'spec_helper'
require_relative '../../lib/ruby_aem/response'

describe 'Response' do
  before do
  end

  after do
  end

  describe 'test initialize' do
    it 'should have status code body and headers' do
      response = RubyAem::Response.new(200, 'some body', {})
      expect(response.status_code).to eq(200)
      expect(response.body).to eq('some body')
      expect(response.headers).to eq({})
    end
  end
end
