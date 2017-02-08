require_relative 'spec_helper'

describe 'Aem' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test get_login_page' do

    it 'should contain readyness indicator' do
      aem = @aem.aem()
      result = aem.get_login_page()
      expect(result.message).to eq('Login page retrieved')
      expect(result.response.body).to include('QUICKSTART_HOMEPAGE')
    end

  end

  describe 'test get_login_page_wait_until_ready' do

    it 'should try once and contain readyness indicator' do
      aem = @aem.aem()
      result = aem.get_login_page_wait_until_ready({
        _retries: {
          max_tries: 60,
          base_sleep_seconds: 2,
          max_sleep_seconds: 2
        }})
      expect(result.message).to eq('Login page retrieved')
      expect(result.response.body).to include('QUICKSTART_HOMEPAGE')
    end

  end

end
