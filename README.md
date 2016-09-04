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

Configuration property:

Flush agent:

Group:

Node:

Package:

Path:

    # check path's existence
    path = aem.path('/etc/designs/cloudservices')
    result = path.activate(true, false)

    # tree activate the path
    path = aem.path('/etc/designs')
    result = path.activate(true, false)

Replication agent:

    replication_agent = aem.replication_agent('author', 'some-replication-agent')

    # create replication agent
    result = replication_agent.create_update('Some replication Agent Title', 'Some replication agent description', 'http://somehost:8080')

    # check replication agent's existence
    result = replication_agent.exists()

    # delete replication agent
    result = replication_agent.delete()

Repository:

    repository = aem.repository()

    # block repository writes
    result = repository.block_writes

    # unblock repository writes
    result = repository.unblock_writes

User:

    user = aem.user('/home/users/s/', 'someuser')

    # create user
    result = user.create('somepassword')

    # check user's existence
    result = user.exists()

    # set user permission
    result = user.set_permission('/etc/replication', 'read:true,modify:true')

    # change user password
    result = user.change_password('somepassword', 'somenewpassword')

    # add user to group
    result = user.add_to_group('/home/groups/s/', 'somegroup')

    # delete user
    result = user.delete()

Result
------

Each of the above method calls returns a [RubyAem::Result](https://github.com/shinesolutions/ruby_aem/blob/master/lib/ruby_aem/result.rb), which contains a status and a message. For example:

    if result.is_failure?
      puts result.message
      exit
    end
