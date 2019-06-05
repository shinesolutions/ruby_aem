require_relative '../spec_helper'
require_relative '../../../lib/ruby_aem/resources/aem_configmgr'

describe 'Aem' do
  before do
    @mock_client = double('mock_client')
  end

  after do
  end

  describe 'test configmgr get' do
    it 'should call client with expected parameters' do
      expect(@mock_client).to receive(:call).once.with(RubyAem::Resources::AemConfigMgr, 'get', {})
      configmgr = RubyAem::Resources::AemConfigMgr.new(@mock_client)
      configmgr.get
    end
  end
end
