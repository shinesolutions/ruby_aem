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
      config_property.create('author', 'org.apache.felix.http')
    end

    it 'should create Apache Felix Jetty Based HTTP Service config property correctly when node exists' do

      # ensure node is created new
      node = @aem.node('/apps/system/config.author', 'org.apache.felix.http')
      if node.exists().data == true
        node.delete()
      end
      result = node.exists()
      expect(result.data).to eq(false)
      result = node.create('sling:OsgiConfig')

      config_property = @aem.config_property('org.apache.felix.https.enable', 'Boolean', true)
      result = config_property.create('author', 'org.apache.felix.http')
      expect(result.message).to eq('Set author org.apache.felix.http config Boolean property org.apache.felix.https.enable=true')

      # wait until Jetty finishes restart following org.apache.felix.http config change
      aem = @aem.aem()
      result = aem.get_login_page_wait_until_ready()
      expect(result.message).to eq('Login page retrieved')
      expect(result.response.body).to include('QUICKSTART_HOMEPAGE')
    end

    it 'should create AEM Password Reset Activator config property correctly when node exists' do

      # ensure node is created new
      node = @aem.node('/apps/system/config.author', 'com.shinesolutions.aem.passwordreset.Activator')
      if node.exists().data == true
        node.delete()
      end
      result = node.exists()
      expect(result.data).to eq(false)
      result = node.create('sling:OsgiConfig')

      config_property = @aem.config_property('pwdreset.authorizables', 'String[]', ['admin', 'orchestrator', 'deployer'])
      result = config_property.create('author', 'com.shinesolutions.aem.passwordreset.Activator')
      expect(result.message).to eq('Set author com.shinesolutions.aem.passwordreset.Activator config String[] property pwdreset.authorizables=["admin", "orchestrator", "deployer"]')

    end
  end

end
