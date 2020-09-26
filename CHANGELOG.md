# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.9.0 - 2020-09-26
### Changed
- Upgrade swagger_aem to 3.4.0

### Fixed
- Fixed AEM Truststore deletion [#41]
- Fix bug of passing empty parameters to swagger-aem [#38]
- Fixed integration tests

## 3.8.0 - 2020-07-06
### Added
- Add waiter method for ssl resource

## 3.7.0 - 2020-05-21
### Added
- Add new api client for Granite api calls
- Add new resource to manage SSL via Granite

### Changed
- Upgrade swagger_aem to 3.3.0

## 3.6.0 - 2020-04-18
### Changed
- Update resource `config_property` to allow the configuration of all OSGI configuration nodes [#31]
- Upgrade swagger_aem to 3.2.0

## 3.4.0 - 2019-08-22
### Added
- Add new dependency swagger_aem_osgi 1.1.0 to gemspec

## 3.3.0 - 2019-08-22
### Added
- Add new api client for configmgr api calls
- Add new resource aem_configmgr
- Add new dependency swagger_aem_osgi 1.1.0

### Changed
- Change SAML Api calls to use configmgr api

## 3.2.1 - 2019-06-05
### Fixed
- Fix swagger_aem dep to 3.1.0 in gemspec

## 3.2.0 - 2019-06-04
### Changed
- Upgrade swagger_aem to 3.1.0

## 3.1.0 - 2019-06-03
### Changed
- Replace nokogiri with rexml + custom sanitisation for html and xml handlers [#26]

## 3.0.0 - 2019-05-14
### Added
- Add application configuration file containing version number

### Changed
- Upgrade swagger_aem to 3.0.0

## 2.5.1 - 2019-02-02
### Fixed
- Fix undefined method get_package_manager_servlet_with_http_info error, set swagger_aem dependency version to 2.5.0

## 2.5.0 - 2019-02-01
### Added
- Add new feature to retrieve CRX Package Manager Servlet status state shinesolutions/aem-aws-stack-builder#214

### Changed
- Update swagger_aem to 2.5.0

## 2.4.0 - 2019-01-07
### Added
- Add spec YAML syntax check to lint target
- Add new bundle configuration for Apache HTTP Components Proxy Configuration shinesolutions/aem-aws-stack-builder#235

### Changed
- Update swagger_aem to 2.4.0

## 2.3.0 - 2018-12-14
### Added
- Add feature to retrieve AEM product informations shinesolutions/swagger-aem#36

### Changed
- Update swagger_aem to 2.3.0

## 2.2.1 - 2018-12-03
### Changed
- Fix missing org_apache_felix_https_truststore param on postConfigApacheFelixJettyBasedHttpService operation

## 2.2.0 - 2018-11-23
### Added
- Add feature to manage AEM Truststore
- Add feature to manage AEM Authorizable Keystore
- Add feature to manage Certificates in AEM Truststore
- Add feature to configure SAML Authentication

### Changed
- Drop Ruby 2.2 support due to openssl 2.1.2

### Removed
- Remove run mode parameter from config property resource

## 2.1.0 - 2018-07-26
### Added
- Add feature path deletion

### Changed
- Update User & Group deletion

### Removed
- Remove support for Ruby 2.1

## 2.0.0 - 2018-06-23
### Changed
- Enable CRXDE prior to testing CRXDE status [#16]

### Removed
- Remove config runmode from config property tests

## 1.4.3 - 2018-04-19
### Added
- Add aem get_packages

## 1.4.2 - 2018-03-19
### Added
- Add get_crxde_status action
- Add verify_ssl option

### Changed
- Fix empty reply error when using https protocol

## 1.4.1 - 2018-01-22
### Changed
- Improve clarity of error message when changing the password but user does not exist
- Fix integration tests that expect default credential, host, and port
- Upgrade yard to >= 0.9.11 and nokogiri to >= 1.8.1 due to security vulnerabilities
- Change required ruby version to >= 2.1 due to nokogiri 1.8.1 requirement

## 1.4.0 - 2017-10-07
### Added
- Add aem get_install_status and get_install_status_wait_until_finished

### Changed
- Integration tests AEM instance parameters are now configurable

## 1.3.3 - 2017-08-21
### Changed
- Prevent reverse replication from triggering on modification

## 1.3.1 - 2017-07-10
### Added
- Add response code 201 as package creation success scenario [#14]

## 1.3.0 - 2017-06-01
### Added
- Add package is_empty, exists, is_built, build_wait_until_ready, get_versions methods

### Changed
- Handle String value on non-String configuration parameters

## 1.2.0 - 2017-05-26
### Changed
- Limit memory consumption when downloading large package file

### Removed
- Remove support for Ruby 1.9

## 1.1.2 - 2017-05-18
### Removed
- Remove unused cq:distribute property from flush agents

## 1.1.1 - 2017-05-12
### Changed
- Fix user and group resources find_authorizable_id action to use GET method
- Fix group#add_member missing leading slash in group path
- Ensure leading slash on user and group path for find_authorizable_id action

## 1.1.0 - 2017-05-09
### Added
- Add aem get_agents method [#8]
- Add SSL support for flush agent

## 1.0.19 - 2017-05-04
### Added
- Add user#change_password error handling [#5]
- Add DavEx Servlet config property alias keyword handling [#4]

### Changed
- Fix postConfigApacheSlingDavExServlet optional parameters [#4]

## 1.0.18 - 2017-04-19
### Added
- Add package uninstall support

## 1.0.17 - 2017-04-12
### Changed
- Allow get_aem_health_check method parameters tags and combine_tags_or  to be optional
- Allow get_aem_health_check_wait_until_ok method parameters tags and combine_tags_or to be optional

## 1.0.16 - 2017-04-11
### Added
- Add SSL support for postAgent operation
- Add AEM Health Check Servlet config support
- Add aem resource get_aem_health_check_wait_until_ok method

## 1.0.15 - 2017-04-04
### Added
- Add timeout option
- Add AEM Password Reset Activator config support

## 1.0.14 - 2017-03-24
### Changed
- Switch from deleteAgent to postAgent operation for all agents delete action

## 1.0.13 - 2017-03-24
### Added
- Add reverse replication agent resource [#6]
- Add outbox replication agent resource

### Changed
- Response 403 is considered as resource not found on user, group, flush agent, and replication agent's exists action [#9]
- Fix sling resource type on flush agent, replication agent, and reverse replication agent [#10]

## 1.0.12 - 2017-03-15
### Changed
- Allow package installation error 500 due to hotfix, service pack, and feature pack's potential false negative error

## 1.0.11 - 2017-03-15
### Added
- Add optional recursive parameter to package install

## 1.0.10 - 2017-03-15
### Added
- Add Apache Felix Jetty Based HTTP Service, Apache Sling GET Servlet, Apache Sling Referrer Filter, Apache Sling DavEx Servlet OSGI config support

## 1.0.8 - 2017-02-19
### Added
- Add package delete_wait_until_ready method

### Changed
- Allow numeric string for retry settings

## 1.0.7 - 2017-02-09
### Changed
- All retry settings are now configurable [#3]

## 1.0.6 - 2017-01-16
### Added
- Add aem resource with get_login_page_wait_until_ready method

### Changed
- Preserve ruby 1.9 and 2.0 support by setting nokogiri dependency to 1.6.x
- Fix package is_installed method to handle packages that haven't been uploaded
- Fix config property's operation in spec file
- Fix node handling in config property creation

## 1.0.2 - 2016-12-20
### Added
- Add package upload_wait_until_ready and install_wait_until_ready methods

### Changed
- Fix flush agent and replication agent initialisation parameters mix up

## 1.0.0 - 2016-11-20
### Added
- Add optional params support for flush agent and replication agent create_update [#2]
- Add response attribute to RubyAem::Result

### Changed
- Fix replication agent creation failure [#1]
- Package upload force parameter is now optional, defaults to true
- Unsuccessful action should now raise RubyAem::Error, replacing failure result
- Resource methods is_* and exists should now return boolean result data

### Removed
- Remove status attribute from RubyAem::Result
- Move resource classes to RubyAem::Resources module

## 0.9.0 - 2016-09-12
### Added
- Initial version
