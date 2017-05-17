### 1.1.2
* Remove unused cq:distribute property from flush agents

### 1.1.1
* Fix user and group resources find_authorizable_id action to use GET method
* Fix group#add_member missing leading slash in group path
* Ensure leading slash on user and group path for find_authorizable_id action

### 1.1.0
* Add aem get_agents method #8
* Add SSL support for flush agent

### 1.0.19
* Add user#change_password error handling #5
* Add DavEx Servlet config property alias keyword handling #4
* Fix postConfigApacheSlingDavExServlet optional parameters #4

### 1.0.18
* Add package uninstall support

### 1.0.17
* Allow get_aem_health_check method parameters tags and combine_tags_or  to be optional
* Allow get_aem_health_check_wait_until_ok method parameters tags and combine_tags_or to be optional

### 1.0.16
* Add SSL support for postAgent operation
* Add AEM Health Check Servlet config support
* Add aem resource get_aem_health_check_wait_until_ok method

### 1.0.15
* Add timeout option
* Add AEM Password Reset Activator config support

### 1.0.14
* Switch from deleteAgent to postAgent operation for all agents delete action

### 1.0.13
* Response 403 is considered as resource not found on user, group, flush agent, and replication agent's exists action #9
* Add reverse replication agent resource #6
* Add outbox replication agent resource
* Fix sling resource type on flush agent, replication agent, and reverse replication agent #10

### 1.0.12
* Allow package installation error 500 due to hotfix, service pack, and feature pack's potential false negative error

### 1.0.11
* Add optional recursive parameter to package install

### 1.0.10
* Add Apache Felix Jetty Based HTTP Service, Apache Sling GET Servlet, Apache Sling Referrer Filter, Apache Sling DavEx Servlet OSGI config support

### 1.0.8
* Add package delete_wait_until_ready method
* Allow numeric string for retry settings

### 1.0.7
* All retry settings are now configurable #3

### 1.0.6
* Preserve ruby 1.9 and 2.0 support by setting nokogiri dependency to 1.6.x
* Fix package is_installed method to handle packages that haven't been uploaded
* Fix config property's operation in spec file
* Fix node handling in config property creation
* Add aem resource with get_login_page_wait_until_ready method

### 1.0.2
* Fix flush agent and replication agent initialisation parameters mix up
* Add package upload_wait_until_ready and install_wait_until_ready methods

### 1.0.0
* Fix replication agent creation failure #1
* Add optional params support for flush agent and replication agent create_update #2
* Package upload force parameter is now optional, defaults to true
* Unsuccessful action should now raise RubyAem::Error, replacing failure result
* Remove status attribute from RubyAem::Result
* Add response attribute to RubyAem::Result
* Move resource classes to RubyAem::Resources module
* Resource methods is_* and exists should now return boolean result data

### 0.9.0
* Initial version
