require_relative 'spec_helper'

describe 'Aem' do
  before do
    @client = init_client
  end

  after do
  end

  describe 'test configmgr resource get' do
    it 'should contain configData indicator' do
      configmgr = @client.aem_configmgr
      result = configmgr.get
      expect(result.message).to eq('Configuration Manager page successfully received')
      expect(result.response.body).to include('configData = ')
    end
  end
end
