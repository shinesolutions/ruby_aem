require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/saml'

describe 'Saml' do
  before do
    @mock_client = double('mock_client')
    @saml = RubyAem::Resources::Saml.new(@mock_client)
  end

  describe 'test create' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Saml,
        'create',
        {
          key_store_password: 'somepassword',
          service_ranking: 15_002,
          idp_http_redirect: true
        }
      )
      @saml.create(key_store_password: 'somepassword', service_ranking: 15_002, idp_http_redirect: true)
    end
  end

  describe 'test delete' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Saml,
        'delete',
        {
          apply: true,
          delete: true
        }
      )
      @saml.delete
    end
  end

  describe 'test get' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(
        RubyAem::Resources::Saml,
        'get',
        {}
      )
      @saml.get
    end
  end
end
