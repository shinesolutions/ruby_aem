require_relative 'spec_helper'

describe 'Aem' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test get_login_page' do
    it 'should contain readyness indicator' do
      aem = @aem.aem
      result = aem.get_login_page
      expect(result.message).to eq('Login page retrieved')
      expect(result.response.body).to include('QUICKSTART_HOMEPAGE')
    end
  end

  describe 'test get_login_page_wait_until_ready' do
    it 'should try once and contain readyness indicator' do
      aem = @aem.aem
      result = aem.get_login_page_wait_until_ready(
        _retries: {
          max_tries: 60,
          base_sleep_seconds: 2,
          max_sleep_seconds: 2
        }
      )
      expect(result.message).to eq('Login page retrieved')
      expect(result.response.body).to include('QUICKSTART_HOMEPAGE')
    end
  end

  describe 'test get_crxde_status' do
    it 'should contain readyness indicator' do
      # ensure CRXDE is enabled
      # vanilla installation of AEM 6.3 and prior defaults to CRXDE enabled
      # vanilla installation of AEM 6.4 defaults to CRXDE disabled
      node = @aem.node('/apps/system/config', 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet')
      node.delete unless node.exists.data == false
      result = node.exists
      expect(result.data).to eq(false)
      node.create('sling:OsgiConfig')

      config_property = @aem.config_property('alias', 'String', '/crx/server')
      result = config_property.create('org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet')
      expect(result.message).to eq('Set org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet config String property alias=/crx/server')

      config_property = @aem.config_property('dav.create-absolute-uri', 'Boolean', true)
      result = config_property.create('org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet')
      expect(result.message).to eq('Set org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet config Boolean property dav.create-absolute-uri=true')

      # check CRXDE status enabled
      aem = @aem.aem
      result = aem.get_crxde_status
      expect(result.data).to eq(true)
      expect(result.message).to eq('CRXDE is enabled')
      expect(result.response.status_code).to eq(200)
    end
  end

  describe 'test get_aem_health_check_wait_until_ok' do
    it 'should try once and contain readyness indicator' do
      aem = @aem.aem
      result = aem.get_aem_health_check_wait_until_ok(
        tags: 'shallow',
        combine_tags_or: false,
        _retries: {
          max_tries: 60,
          base_sleep_seconds: 2,
          max_sleep_seconds: 2
        }
      )
      expect(result.message).to eq('AEM health check retrieved')
      expect(result.data.length).to eq(1)
      expect(result.data[0]['name']).to eq('Smoke Health Check')
      expect(result.data[0]['status']).to eq('OK')
    end
  end

  describe 'test get_agents' do
    it 'should succeed' do
      # ensure there is at least one agent
      flush_agent = @aem.flush_agent('author', 'some-flush-agent')
      flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080') if flush_agent.exists.data == false

      result = @aem.aem.get_agents('author')
      expect(result.message).to eq('Retrieved agents on author')
      expect(result.data.length).not_to eq(0)
    end
  end

  describe 'test get_install_status' do
    it 'should contain finished indicator' do
      aem = @aem.aem
      result = aem.get_install_status
      expect(result.message).to eq('Install status retrieved successfully')
      expect(result.response.body.status.finished).to equal(true)
    end
  end

  describe 'test get_install_status_wait_until_finished' do
    it 'should try once and contain readyness indicator' do
      aem = @aem.aem
      result = aem.get_install_status_wait_until_finished(
        _retries: {
          max_tries: 60,
          base_sleep_seconds: 2,
          max_sleep_seconds: 2
        }
      )
      expect(result.message).to eq('Install status retrieved successfully')
      expect(result.response.body.status.finished).to equal(true)
    end
  end

  describe 'test get_packages' do
    it 'should return a list of all packages' do
      aem = @aem.aem
      result = aem.get_packages
      expect(result.message).to eq('All packages list retrieved successfully')
      expect(result.data.length).to be >= 1
      puts result.data
    end
  end

  describe 'test get_product_info' do
    it 'should return product infos' do
      aem = @aem.aem
      result = aem.get_product_info

      expect(result.message).to eq('AEM Product informations found')
      expect(result.data.length).to be >= 1
      puts result.data
    end
  end
end
