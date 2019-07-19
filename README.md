[![Build Status](https://img.shields.io/travis/shinesolutions/ruby_aem.svg)](http://travis-ci.org/shinesolutions/ruby_aem)
[![Published Version](https://badge.fury.io/rb/ruby_aem.svg)](https://rubygems.org/gems/ruby_aem)
[![Known Vulnerabilities](https://snyk.io/test/github/shinesolutions/ruby_aem/badge.svg)](https://snyk.io/test/github/shinesolutions/ruby_aem)

ruby_aem
--------

ruby_aem is a Ruby client for [Adobe Experience Manager (AEM)](http://www.adobe.com/au/marketing-cloud/enterprise-content-management.html) API.
It is written on top of [swagger_aem](https://github.com/shinesolutions/swagger-aem/blob/master/ruby/README.md) and provides resource-oriented API and convenient response handling.

Learn more about ruby_aem:

* [Installation](https://github.com/shinesolutions/ruby_aem#installation)
* [Usage](https://github.com/shinesolutions/ruby_aem#usage)
* [Result Model](https://github.com/shinesolutions/ruby_aem#result)
* [Error Handling](https://github.com/shinesolutions/ruby_aem#error-handling)
* [Testing](https://github.com/shinesolutions/ruby_aem#testing)
* [Versions History](https://github.com/shinesolutions/ruby_aem/blob/master/docs/versions.md)

ruby_aem is part of [AEM OpenCloud](https://aemopencloud.io) platform but it can be used as a stand-alone.

Installation
------------

    gem install ruby_aem

Usage
-----

Initialise client:

    require 'ruby_aem'

    aem = RubyAem::Aem.new({
      username: 'admin',
      password: 'admin',
      protocol: 'http',
      host: 'localhost',
      port: 4502,
      timeout: 300,
      verify_ssl: true,
      debug: false
    })

Aem:

    # wait until AEM login page is ready
    aem = aem.aem
    result = aem.get_login_page_wait_until_ready({
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }})

    # wait until AEM Health Check has OK status
    # this requires aem-healthcheck package to be installed
    # https://github.com/shinesolutions/aem-healthcheck
    aem = aem.aem
    result = aem.get_aem_health_check_wait_until_ok({
      tags: 'shallow',
      combine_tags_or: false,
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }})

    # get an array of all agent names within AEM author or publish instance
    aem = aem.aem
    result = aem.get_agents('author')

    # get an array of AEM product informations
    aem = aem.aem
    result = aem.get_product_info

AEM Config Manager:

    # Create OpenAPI Spec of all configuration nodes
    configmgr = aem.aem_configmgr('./source_api.yaml', 'api_dest.yaml')
    result = configmgr.get_all_configuration_nodes

Bundle:

    # stop bundle
    bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
    result = bundle.stop

    # start bundle
    bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
    result = bundle.start

Configuration property:

    config_property = aem.config_property('someproperty', 'Boolean', true)

    # set config property on /apps/system/config/somenode
    result = config_property.create('somenode')

Flush agent:

    flush_agent = aem.flush_agent('author', 'some-flush-agent')

    # create or update flush agent
    opts = { log_level: 'info', retry_delay: 60_000 }
    result = flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080', opts)

    # check flush agent's existence
    result = flush_agent.exists

    # delete flush agent
    result = flush_agent.delete

Group:

    # create group
    group = aem.group('/home/groups/s/', 'somegroup')

    # check group's existence
    result = group.exists

    # set group permission
    result = group.set_permission('/etc/replication', 'read:true,modify:true')

    # add another group as a member
    member_group = aem.group('/home/groups/s/', 'somemembergroup')
    result = member_group.create
    result = group.add_member('somemembergroup')

    # delete group
    result = group.delete

Node:

    node = aem.node('/apps/system/', 'somefolder')

    # create node
    result = node.create('sling:Folder')

    # check node's existence
    result = node.exists

    # delete node
    result = node.delete

Package:

    package = aem.package('somepackagegroup', 'somepackage', '1.2.3')

    # upload package located at /tmp/somepackage-1.2.3.zip
    opts = { force: true }
    result = package.upload('/tmp', opts)

    # check whether package is uploaded
    result = package.is_uploaded

    # install package
    opts = { recursive: true }
    result = package.install(opts)

    # uninstall package
    result = package.uninstall(opts)

    # check whether package is installed
    result = package.is_installed

    # replicate package
    result = package.replicate

    # download package to /tmp directory
    result = package.download('/tmp')

    # create package
    result = package.create

    # build package
    result = package.build

    # build package and wait until package is built (package exists and size is not empty)
    result = package.build_wait_until_ready

    # check whether package is built
    result = package.is_built

    # update package filter
    result = package.update('[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]')

    # get package filter
    result = package.get_filter

    # activate filter
    results = package.activate_filter(true, false)

    # list all packages
    result = package.list_all

    # check whether package is empty
    result = package.is_empty

    # get all versions of the package
    result = package.get_versions

Path:

    # check path's existence
    path = aem.path('/etc/designs/cloudservices')
    result = path.activate(true, false)

    # tree activate the path
    path = aem.path('/etc/designs')
    result = path.activate(true, false)

Replication agent:

    replication_agent = aem.replication_agent('author', 'some-replication-agent')

    # create or update replication agent
    opts = {
      transport_user: 'admin',
      transport_password: 'admin',
      log_level: 'info',
      retry_delay: 60_000
    }
    result = replication_agent.create_update('Some Replication Agent Title', 'Some replication agent description', 'http://somehost:8080', opts)

    # check replication agent's existence
    result = replication_agent.exists

    # delete replication agent
    result = replication_agent.delete

Outbox replication agent:

    outbox_replication_agent = aem.outbox_replication_agent('publish', 'some-outbox-replication-agent')

    # create or update outbox replication agent
    opts = {
      user_id: 'admin',
      log_level: 'info'
    }
    result = outbox_replication_agent.create_update('Some Outbox Replication Agent Title', 'Some outbox replication agent description', 'http://somehost:8080', opts)

    # check outbox replication agent's existence
    result = outbox_replication_agent.exists

    # delete outbox replication agent
    result = outbox_replication_agent.delete

Reverse replication agent:

    reverse_replication_agent = aem.reverse_replication_agent('author', 'some-reverse-replication-agent')

    # create or update reverse replication agent
    opts = {
      transport_user: 'admin',
      transport_password: 'admin',
      log_level: 'info',
      retry_delay: 60_000
    }
    result = reverse_replication_agent.create_update('Some Reverse Replication Agent Title', 'Some reverse replication agent description', 'http://somehost:8080', opts)

    # check reverse replication agent's existence
    result = reverse_replication_agent.exists

    # delete reverse replication agent
    result = reverse_replication_agent.delete

Repository:

    repository = aem.repository

    # block repository writes
    result = repository.block_writes

    # unblock repository writes
    result = repository.unblock_writes

Saml:

    saml = aem.saml

    # Configure SAML for AEM
    opts = {
      key_store_password: 'someKeystorePassword',
      service_ranking: 5002,
      idp_http_redirect: true,
      create_user: true,
      default_redirect_url: '/some_sites.html',
      user_id_attribute: 'someUserID',
      default_groups: ['some-groups'],
      idp_cert_alias: 'some_alias_name_1234'.
      add_group_memberships: true,
      path: ['/'],
      synchronize_attributes: [
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname\=profile/givenName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname\=profile/familyName',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress\=profile/email'
      ],
      clock_tolerance: 60,
      group_membership_attribute: 'http://temp/variable/aem-groups',
      idp_url: 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx?RequestBinding\=HTTPPost&loginToRp\=https://prod-aemauthor.com/saml_login',
      logout_url: 'https://federation.prod.com/adfs/ls/IdpInitiatedSignOn.aspx',
      service_provider_entity_id: 'https://prod-aemauthor.com/saml_login',
      handle_logout: true,
      sp_private_key_alias: '',
      use_encryption: false,
      name_id_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:transient',
      digest_method	: 'http://www.w3.org/2001/04/xmlenc#sha256',
      signature_method	: 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
    }
    result = saml.create(opts)

    # Delete  the SAML Configuration
    result = saml.delete

    # Get the current SAML Configuration
    result = saml.get

Authorizable Keystore:

    keystore = aem.authorizable_keystore('/home/users/system', 'authentication-service')

    # Create Keystore
    keystore_password = 'password'
    result = keystore.create(keystore_password)

    # Change Keystore Password
    old_keystore_password = 'old_password'
    new_keystore_password = 'new_password'
    change_password(old_keystore_password, new_keystore_password)

    # Delete keystore
    result = keystore.delete

    # Delete Certificate Chain from Keystore
    private_key_alias = 'alias_123'
    delete_certificate_chain(private_key_alias)

    # Download keystore to a specific F=file
    opts = { file: '/root/saved_keystore.p12' }
    result = keystore.download(**opts)

    # Download keystore to a specific directory
    opts = { path: '/root' }
    result = keystore.download_keystore(**opts)

    # Check if keystore exists
    result = keystore.exists

    # Check if Alias exists
    private_key_alias = 'alias_123'
    exists_certificate_chain(private_key_alias)

    # Get info about an existing keystore
    result = keystore.get

    # Get info about an Certificate Chain in the Keystore
    private_key_alias = 'alias_123'
    get_certificate_chain(private_key_alias)

    # Get info about an keystore provided as a file
    file_path = '/root/store.p12'
    keystore_password = 'admin'
    result = keystore.read_keystore(file_path, keystore_password)

    # Read certificate info from file
    file_path = '/root/store.p12'
    read_cert_from_file(file_path)

    # Read certificate info provided as string
    certificate_raw = '-----BEGIN CERTIFICATE-----
    MIIEpDCABCDEFGHIJKLMNOPQRSTUVWXYZ
    -----END CERTIFICATE-----'
    def read_certificate_raw(certificate_raw)

    # Upload a keystore backup
    file_path = '/root/store.p12'
    new_alias = alias_123
    key_store_file_password = 'admin'
    private_key_alias = 'alias_456'
    private_key_password = 'private_password'

    result = keystore.upload(file_path, new_alias, key_store_file_password, private_key_alias, private_key_password)

    # Force upload a keystore backup
    file_path = '/root/store.p12'
    new_alias = alias_123
    key_store_file_password = 'admin'
    private_key_alias = 'alias_456'
    private_key_password = 'private_password'
    force = true

    result = keystore.upload(file_path, new_alias, key_store_file_password, private_key_alias, private_key_password, force)

    # Upload Certificate Chain into the Keystore
    private_key_alias = 'alias_456'
    certificate = '/tmp/cert.crt'
    private_key = '/tmp/private_key.der'
    upload_certificate_chain(private_key_alias, certificate, private_key)

    # Upload Certificate Chain into the Keystore with certificate provided as string
    certificate_raw = '-----BEGIN CERTIFICATE-----
    MIIEpDCABCDEFGHIJKLMNOPQRSTUVWXYZ
    -----END CERTIFICATE-----'
    private_key_alias = 'alias_456'
    private_key = '/tmp/private_key.der'
    upload_certificate_chain_raw(private_key_alias, certificate_raw, private_key)

    # Wait till keystore backup is uploaded
    opts = {
      file_path: '/root/saved_keystore.p12',
      new_alias: alias_123,
      key_store_file_password: 'admin',
      private_key_alias: 'alias_456',
      private_key_password: 'private_password',
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }
    }
    result = keystore.upload_keystore_from_file_wait_until_ready(opts)

    # Wait until Certificate Chain is uploaded into the keystore
    opts = {
      private_key_alias: 'alias_456',
      certificate: '/tmp/cert.crt',
      private_key: '/tmp/private_key.der',
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }
    }

    upload_certificate_chain_from_file_wait_until_ready(opts)

    # Wait until Certificate Chain is uploaded into the keystore with certificate provided as string
    opts = {
      private_key_alias: 'alias_456',
      certificate_raw : '-----BEGIN CERTIFICATE-----
      MIIEpDCABCDEFGHIJKLMNOPQRSTUVWXYZ
      -----END CERTIFICATE-----',
      private_key: '/tmp/private_key.der',
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }
    }

    upload_certificate_chain_from_file_wait_until_ready(opts)

Truststore:

    truststore = aem.truststore

    # Create Truststore
    truststore_password = 'admin'
    result = truststore.create_truststore(truststore_password)

    # Delete Truststore
    truststore_password = 'admin'
    result = truststore.delete_truststore

    # Download Truststore to a specific F=file
    file = '/root/saved_truststore.p12'
    result = truststore.download_truststore(file: file)

    # Download Truststore to a specific directory
    path = '/root'
    result = truststore.download_truststore(path: path)

    # Check if Truststore exists
    result = truststore.exists_truststore

    # Get info about an existing Truststore
    result = truststore.get_truststore_info

    # Get info about an Truststore provided as a file
    opts = {
      file_path: '/root/saved_truststore.p12'
      truststore_password: 'admin',
    }
    result = truststore.read_truststore(opts)

    # Upload a Truststore backup
    file_path = '/root/saved_truststore.p12'
    result = truststore.upload_truststore_from_file(file_path: file_path)

    # Force upload a Truststore backup
    opts = {
      file_path: '/root/saved_truststore.p12'
      force: true,
    }
    result = truststore.upload_truststore_from_file(opts)

    # Wait till Truststore backup is uploaded
    opts = {
      file_path: '/root/saved_truststore.p12',
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }
    }
    result = truststore.upload_truststore_from_file(opts)

    # Force upload of a Truststore backup and wait till it is uploaded
    opts = {
      file_path: '/root/saved_truststore.p12',
      force: true,
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }
    }
    result = truststore.upload_truststore_from_file(opts)


Certificate:

    certificate = aem.truststore

    # Delete Certificate via Truststore alias name
    certalias = 'alias_1234'
    result = certificate.delete_cert(certalias: certalias)

    # Delete Certificate via serial number
    serial = 1234567890
    result = certificate.delete_cert(certalias: serial)

    # Check if a Certificate exists via Truststore alias name
    certalias = 'alias_1234'
    result = certificate.exists_certs(certalias: certalias)

    # Check if a Certificate exists via serial number
    serial = 1234567890
    result = certificate.exists_certs(certalias: serial)

    # Export a certificate via serial number
    opts = {
      serial: 1234567890,
      truststore_password: 'admin',
    }
    result = certificate.export_certificate(opts)

    # Get a Certificate via Truststore alias name
    certalias = 'alias_1234'
    result = certificate.get_certificate(certalias: certalias)

    # Get a Certificate via serial number
    serial = 1234567890
    result = certificate.get_certificate(certalias: serial)

    # Read certificate info provided via string
    certificate_raw = '-----BEGIN CERTIFICATE-----
    MIIEpDCABCDEFGHIJKLMNOPQRSTUVWXYZ
    -----END CERTIFICATE-----'
    result = certificate.read_cert_raw(certificate_raw)

    # Read certificate info provided via file
    file_path = '/root/cert.crt'
    result = certificate.read_cert_from_file(file_path)

    # Upload a certificate provided via string
    certificate_raw = '-----BEGIN CERTIFICATE-----
    MIIEpDCABCDEFGHIJKLMNOPQRSTUVWXYZ
    -----END CERTIFICATE-----'
    result = certificate.upload_cert_raw(certificate_raw)

    # Upload a certificate provided via file
    file_path = '/root/cert.crt'
    result = certificate.upload_cert_from_file(file_path)

    # Upload a certificate via file and wait till it is uploaded
    opts = {
      file_path:'/root/cert.crt'
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }
    }
    result = certificate.upload_cert_from_file_wait_until_ready(opts)

    # Read certificate info provided via string and wait till it is uploaded
    opts = {
      certificate_raw = '-----BEGIN CERTIFICATE-----
      MIIEpDCABCDEFGHIJKLMNOPQRSTUVWXYZ
      -----END CERTIFICATE-----'
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }
    }
    result = certificate.upload_cert_raw_wait_until_ready(opts)

User:

    user = aem.user('/home/users/s/', 'someuser')

    # create user
    result = user.create('somepassword')

    # check user's existence
    result = user.exists

    # set user permission
    result = user.set_permission('/etc/replication', 'read:true,modify:true')

    # change user password
    result = user.change_password('somepassword', 'somenewpassword')

    # add user to group
    result = user.add_to_group('/home/groups/s/', 'somegroup')

    # delete user
    result = user.delete

Result
------

Each of the above method calls returns a [RubyAem::Result](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Result.html), which contains message, [RubyAem::Response](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Response.html), and data payload. For example:

    bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
    result = bundle.stop
    puts result.message
    puts result.response.status_code
    puts result.response.body
    puts result.response.headers
    puts result.data

Error Handling
--------------

Any API error will be thrown as [RubyAem::Error](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Error.html) .

    begin
      bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.stop
    rescue RubyAem::Error => e
      puts e.message
      puts e.result.response.status_code
      puts e.result.response.body
      puts e.result.response.headers
      puts e.result.data
    end

Testing
-------

Integration tests require an AEM instance with [Shine Solutions AEM Health Check](https://github.com/shinesolutions/aem-healthcheck) package installed.

By default it uses AEM running on http://localhost:4502 with `admin` username and `admin` password. AEM instance parameters can be configured using environment variables `aem_protocol`, `aem_host`, `aem_port`, `aem_username`, `aem_password`, and `aem_debug`.
