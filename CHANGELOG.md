### 1.0.8
*

### 1.0.7
* All retry settings are now configurable #3

### 1.0.6
* Preserve ruby 1.9 and 2.0 support by setting nokogiri dependency to 1.6.x
* Fix package is_installed method to handle packages that haven't been uploaded
* Fix config property's operation in spec file
* Fix node handling in config property creation
* Add aem resource with get_login_page_until_ready method

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
