[![Build Status](https://img.shields.io/travis/shinesolutions/ruby_aem.svg)](http://travis-ci.org/shinesolutions/ruby_aem)

ruby_aem
--------

ruby_aem is a Ruby client for [Adobe Experience Manager (AEM)](http://www.adobe.com/au/marketing-cloud/enterprise-content-management.html) API.
It is written on top of [swagger_aem](https://github.com/shinesolutions/swagger-aem/blob/master/ruby/README.md) and provides resource-oriented API and convenient response handling.

| ruby_aem                                                            | Supported AEM          | Supported Ruby          |
|---------------------------------------------------------------------|------------------------|-------------------------|
| [0.9.0](https://shinesolutions.github.io/ruby_aem/0.9.0/index.html) | 6.0, 6.1, 6.2          | 1.9, 2.0, 2.1, 2.2, 2.3 |

Install
-------

    gem install ruby_aem

Usage
-----

Initialise client:

    aem = RubyAem::Aem.new({
      :username => 'admin',
      :password => 'admin',
      :protocol => 'http',
      :host => 'localhost',
      :port => 4502,
      :debug => false
