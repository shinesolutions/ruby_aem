[![Build Status](https://github.com/shinesolutions/ruby_aem/workflows/CI/badge.svg)](https://github.com/shinesolutions/ruby_aem/actions?query=workflow%3ACI)
[![Published Version](https://badge.fury.io/rb/ruby_aem.svg)](https://rubygems.org/gems/ruby_aem)
[![Known Vulnerabilities](https://snyk.io/test/github/shinesolutions/ruby_aem/badge.svg)](https://snyk.io/test/github/shinesolutions/ruby_aem)

# ruby_aem

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

## Installation

```shell
gem install ruby_aem
```

## Usage

### Initialise client

```ruby
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
```

### Aem

```ruby
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
```

### AEM Config Manager

```ruby
# Create OpenAPI Spec of all configuration nodes
configmgr = aem.aem_configmgr('./source_api.yaml', 'api_dest.yaml')
result = configmgr.get_all_configuration_nodes
```

### Bundle

```ruby
# stop bundle
bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
result = bundle.stop

# start bundle
bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
result = bundle.start
```

### Configuration property

```ruby
config_property = aem.config_property('someproperty', 'Boolean', true)

# set config property on /apps/system/config/somenode
result = config_property.create('somenode')
```

### Flush agent

```ruby
flush_agent = aem.flush_agent('author', 'some-flush-agent')

# create or update flush agent
opts = { log_level: 'info', retry_delay: 60_000 }
result = flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080', opts)

# check flush agent's existence
result = flush_agent.exists

# delete flush agent
result = flush_agent.delete
```

### Group

```ruby
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
```

### Node

```ruby
node = aem.node('/apps/system/', 'somefolder')

# create node
result = node.create('sling:Folder')

# check node's existence
result = node.exists

# delete node
result = node.delete
```

### Package

```ruby
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
```

### Path

```ruby
# check path's existence
path = aem.path('/etc/designs/cloudservices')
result = path.activate(true, false)

# tree activate the path
path = aem.path('/etc/designs')
result = path.activate(true, false)
```

### Replication agent

```ruby
replication_agent = aem.replication_agent('author', 'some-replication-agent')

# create or update replication agent
opts = {
  transport_user: 'admin',
  transport_password: 'admin',
  log_level: 'info',
  retry_delay: 60_000,
  ssl: 'relaxed'
}
result = replication_agent.create_update('Some Replication Agent Title', 'Some replication agent description', 'http://somehost:8080', opts)

# check replication agent's existence
result = replication_agent.exists

# delete replication agent
result = replication_agent.delete
```

### Outbox replication agent

```ruby
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
```

### Reverse replication agent

```ruby
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
```

### Repository

```ruby
repository = aem.repository

# block repository writes
result = repository.block_writes

# unblock repository writes
result = repository.unblock_writes
```

### Saml

```ruby
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
  digest_method: 'http://www.w3.org/2001/04/xmlenc#sha256',
  signature_method: 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
}
result = saml.create(opts)

# Delete  the SAML Configuration
result = saml.delete

# Get the current SAML Configuration
result = saml.get
```

### SSL

```ruby
ssl = aem.ssl

# enable SSL
# authorizable keystore and truststore will be created if they don't exist
opts = {
  keystore_password: 'somekeystorepassword',
  truststore_password: 'sometruststorepassword',
  https_hostname: 'localhost',
  https_port: 5432,
  certificate_file_path: '/tmp/cert_ssl.crt',
  privatekey_file_path: '/tmp/cert_ssl.der'
}
result = ssl.enable(opts)

# enable SSL and wait until SSL is enabled
opts = {
  keystore_password: 'somekeystorepassword',
  truststore_password: 'sometruststorepassword',
  https_hostname: 'localhost',
  https_port: 5432,
  certificate_file_path: '/tmp/cert_ssl.crt',
  privatekey_file_path: '/tmp/cert_ssl.der',
  _retries: {
    max_tries: 60,
    base_sleep_seconds: 2,
    max_sleep_seconds: 2
  }
}
result = ssl.enable_wait_until_ready(opts)

# retrieve SSL configuration
result = ssl.get

# check whether SSL is enabled
result = ssl.is_enabled

# disable SSL
result = ssl.disable
```

### Authorizable Keystore

```ruby
keystore = aem.authorizable_keystore('/home/users/system', 'authentication-service')

# create keystore
result = keystore.create('somekeystorepassword')

# check keystore's existence
result = keystore.exists

# retrieve keystore info
result = keystore.info

# change keystore password
result = keystore.change_password('somekeystorepassword', 'somenewkeystorepassword')

# download keystore to a file
result = keystore.download('/tmp/keystore.p12')

# delete keystore
result = keystore.delete
```

### Truststore

```ruby
truststore = aem.truststore

# create truststore
result = truststore.create('sometruststorepassword')

# check truststore's existence
result = truststore.exists

# retrieve truststore info
result = truststore.info

# download truststore to a file
result = truststore.download('/tmp/truststore.p12')

# read a truststore file on the filesystem as an OpenSSL::PKCS12 object
# this method does not call AEM and does not return a RubyAem::Result
pkcs12 = truststore.read('/tmp/truststore.p12', 'sometruststorepassword')

# upload a truststore file, existing truststore will be overwritten by default
result = truststore.upload('/tmp/truststore.p12')

# upload a truststore file without overwriting existing truststore
result = truststore.upload('/tmp/truststore.p12', force: false)

# upload a truststore file and wait until the truststore exists
opts = {
  force: true,
  _retries: {
    max_tries: 60,
    base_sleep_seconds: 2,
    max_sleep_seconds: 2
  }
}
result = truststore.upload_wait_until_ready('/tmp/truststore.p12', opts)

# delete truststore
result = truststore.delete
```

### Certificate

```ruby
# a certificate within AEM Truststore is identified by its serial number
certificate = aem.certificate('15863505968020663268')

# import a certificate file into AEM Truststore
result = certificate.import('/tmp/cert.crt')

# create is an alias to import
result = certificate.create('/tmp/cert.crt')

# import a certificate file and wait until the certificate exists
opts = {
  _retries: {
    max_tries: 60,
    base_sleep_seconds: 2,
    max_sleep_seconds: 2
  }
}
result = certificate.import_wait_until_ready('/tmp/cert.crt', opts)

# check certificate's existence
result = certificate.exists

# export the certificate from AEM Truststore
# result data contains the certificate as an OpenSSL::X509::Certificate object
result = certificate.export('sometruststorepassword')

# delete certificate
result = certificate.delete
```

### Certificate chain

```ruby
# a certificate chain is identified by its private key alias
# within the authorizable keystore of an AEM user
certificate_chain = aem.certificate_chain('someprivatekeyalias', '/home/users/system', 'authentication-service')

# import a certificate chain file and its private key file into the authorizable keystore
result = certificate_chain.import('/tmp/cert_chain.crt', '/tmp/private_key.der')

# create is an alias to import
result = certificate_chain.create('/tmp/cert_chain.crt', '/tmp/private_key.der')

# import a certificate chain and wait until the certificate chain exists
opts = {
  _retries: {
    max_tries: 60,
    base_sleep_seconds: 2,
    max_sleep_seconds: 2
  }
}
result = certificate_chain.import_wait_until_ready('/tmp/cert_chain.crt', '/tmp/private_key.der', opts)

# check certificate chain's existence
result = certificate_chain.exists

# delete certificate chain
result = certificate_chain.delete
```

### User

```ruby
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
```

## Result

Each of the above method calls returns a [RubyAem::Result](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Result.html), which contains message, [RubyAem::Response](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Response.html), and data payload. For example:

```ruby
bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
result = bundle.stop
puts result.message
puts result.response.status_code
puts result.response.body
puts result.response.headers
puts result.data
```

## Error Handling

Any API error will be thrown as [RubyAem::Error](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Error.html) .

```ruby
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
```

## Testing

Integration tests require an AEM instance with [Shine Solutions AEM Health Check](https://github.com/shinesolutions/aem-healthcheck) package installed.

By default it uses AEM running on http://localhost:4502 with `admin` username and `admin` password. AEM instance parameters can be configured using environment variables `aem_protocol`, `aem_host`, `aem_port`, `aem_username`, `aem_password`, and `aem_debug`.
