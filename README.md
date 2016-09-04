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

    require 'ruby_aem'

    aem = RubyAem::Aem.new({
      :username => 'admin',
      :password => 'admin',
      :protocol => 'http',
      :host => 'localhost',
      :port => 4502,
      :debug => false

Bundle:

    # stop bundle
    bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
    result = bundle.stop()

    # start bundle
    bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
    result = bundle.start()

Result
------

Each of the above method calls returns a [RubyAem::Result](https://github.com/shinesolutions/ruby_aem/blob/master/lib/ruby_aem/result.rb), which contains a status and a message. For example:

    if result.is_failure?
      puts result.message
      exit
    end
