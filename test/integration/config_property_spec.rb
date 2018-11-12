require_relative 'spec_helper'

describe 'ConfigProperty' do
  before do
    @aem = init_client
  end

  after do
  end

  describe 'test properties create SSL config' do
    it 'should create a sling folder by default when path node does not exist' do
      config_property = @aem.config_property('someproperty', 'Boolean', true)
      config_property.create('org.apache.felix.http')
    end

    it 'should create Apache Felix Jetty Based HTTP Service config property correctly when node exists' do
      # ensure node is created new
      node = @aem.node('/apps/system/config', 'org.apache.felix.http')
      node.delete unless node.exists.data == false
      result = node.exists
      expect(result.data).to eq(false)
      node.create('sling:OsgiConfig')

      config_property = @aem.config_property('org.apache.felix.https.enable', 'Boolean', true)
      result = config_property.create('org.apache.felix.http')
      expect(result.message).to eq('Set org.apache.felix.http config Boolean property org.apache.felix.https.enable=true')

      # wait until Jetty finishes restart following org.apache.felix.http config change
      aem = @aem.aem
      result = aem.get_login_page_wait_until_ready
      expect(result.message).to eq('Login page retrieved')
      expect(result.response.body).to include('QUICKSTART_HOMEPAGE')
    end

    it 'should create AEM Password Reset Activator config property correctly when node exists' do
      # ensure node is created new
      node = @aem.node('/apps/system/config', 'com.shinesolutions.aem.passwordreset.Activator')
      node.delete unless node.exists.data == false
      result = node.exists
      expect(result.data).to eq(false)
      node.create('sling:OsgiConfig')

      config_property = @aem.config_property('pwdreset.authorizables', 'String[]', %w[admin orchestrator deployer])
      result = config_property.create('com.shinesolutions.aem.passwordreset.Activator')
      expect(result.message).to eq('Set com.shinesolutions.aem.passwordreset.Activator config String[] property pwdreset.authorizables=["admin", "orchestrator", "deployer"]')
    end

    it 'should create AEM Health Check Servlet config property correctly when node exists' do
      # ensure node is created new
      node = @aem.node('/apps/system/config', 'com.shinesolutions.healthcheck.hc.impl.ActiveBundleHealthCheck')
      node.delete unless node.exists.data == false
      result = node.exists
      expect(result.data).to eq(false)
      node.create('sling:OsgiConfig')

      config_property = @aem.config_property('bundles.ignored', 'String[]', ['com.day.cq.dam.dam-webdav-support'])
      result = config_property.create('com.shinesolutions.healthcheck.hc.impl.ActiveBundleHealthCheck')
      expect(result.message).to eq('Set com.shinesolutions.healthcheck.hc.impl.ActiveBundleHealthCheck config String[] property bundles.ignored=["com.day.cq.dam.dam-webdav-support"]')
    end
  end
end
