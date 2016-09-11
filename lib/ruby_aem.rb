=begin
Copyright 2016 Shine Solutions

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

require 'ruby_aem/bundle'
require 'ruby_aem/client'
require 'ruby_aem/config_property'
require 'ruby_aem/flush_agent'
require 'ruby_aem/group'
require 'ruby_aem/node'
require 'ruby_aem/package'
require 'ruby_aem/path'
require 'ruby_aem/replication_agent'
require 'ruby_aem/repository'
require 'ruby_aem/user'
require 'swagger_aem'
require 'yaml'

module RubyAem
  # Aem class represents an AEM client instance.
  class Aem

    # Initialise a Ruby AEM instance.
    #
    # @param conf configuration hash of the following configuration values:
    # - username: username used to authenticate to AEM instance
    # - password: password used to authenticate to AEM instance
    # - protocol: AEM instance protocol (http or https)
    # - host: AEM instance host name
    # - port: AEM instance port
    # - debug: if true, then additional debug messages will be included
    # @return new RubyAem::Aem instance
    def initialize(conf = {})

      conf[:username] ||= 'admin'
      conf[:password] ||= 'admin'
      conf[:protocol] ||= 'http'
      conf[:host] ||= 'localhost'
      conf[:port] ||= 4502
      conf[:debug] ||= false

      SwaggerAemClient.configure { |swagger_conf| [
        swagger_conf.host = "#{conf[:protocol]}://#{conf[:host]}:#{conf[:port]}",
        swagger_conf.username = conf[:username],
        swagger_conf.password = conf[:password],
        swagger_conf.debugging = conf[:debug],
        swagger_conf.params_encoding = :multi
      ]}

      apis = {
        :console => SwaggerAemClient::ConsoleApi.new,
        :cq => SwaggerAemClient::CqApi.new,
        :crx => SwaggerAemClient::CrxApi.new,
        :sling => SwaggerAemClient::SlingApi.new
      }

      spec = YAML.load_file(File.expand_path('../../conf/spec.yaml', __FILE__))

      @client = RubyAem::Client.new(apis, spec)
    end

    # Create a bundle instance.
    #
    # @param name the bundle's name, e.g. com.adobe.cq.social.cq-social-forum
    # @return new RubyAem::Bundle instance
    def bundle(name)
      RubyAem::Bundle.new(@client, name)
    end

    # Create a path instance.
    #
    # @param name the name of the path, e.g. /etc/designs
    # @return new RubyAem::Path instance
    def path(name)
      RubyAem::Path.new(@client, name)
    end

    # Create a config property instance.
    #
    # @param name the property's name
    # @param type the property's type, e.g. Boolean
    # @param value the property's value, e.g. true
    # @return new RubyAem::ConfigProperty instance
    def config_property(name, type, value)
      RubyAem::ConfigProperty.new(@client, name, type, value)
    end

    # Create a flush agent instance.
    #
    # @param run_mode AEM run mode: author or publish
    # @param name the flush agent's name, e.g. some-flush-agent
    # @return new RubyAem::FlushAgent instance
    def flush_agent(name, run_mode)
      RubyAem::FlushAgent.new(@client, name, run_mode)
    end

    # Create a group instance.
    #
    # @param path the path to group node, e.g. /home/groups/s/
    # @param name the name of the AEM group, e.g. somegroup
    # @return new RubyAem::Group instance
    def group(path, name)
      RubyAem::Group.new(@client, path, name)
    end

    # Create a node instance.
    #
    # @param path the path to the node, e.g. /apps/system/
    # @param name the node name, e.g. somenode
    # @return new RubyAem::Node instance
    def node(path, name)
      RubyAem::Node.new(@client, path, name)
    end

    # Create a package instance.
    #
    # @param group_name the group name of the package, e.g. somepackagegroup
    # @param package_name the name of the package, e.g. somepackage
    # @param package_version the version of the package, e.g. 1.2.3
    # @return new RubyAem::Package instance
    def package(group_name, package_name, package_version)
      RubyAem::Package.new(@client, group_name, package_name, package_version)
    end

    # Create a replication agent instance.
    #
    # @param run_mode AEM run mode: author or publish
    # @param name the replication agent's name, e.g. some-replication-agent
    # @return new RubyAem::ReplicationAgent instance
    def replication_agent(name, run_mode)
      RubyAem::ReplicationAgent.new(@client, name, run_mode)
    end

    # Create a repository instance.
    #
    # @return new RubyAem::Repository instance
    def repository
      RubyAem::Repository.new(@client)
    end

    # Create a user instance.
    #
    # @param path the path to user node, e.g. /home/users/s/
    # @param name the username of the AEM user, e.g. someuser, admin, johncitizen
    # @return new RubyAem::User instance
    def user(path, name)
      RubyAem::User.new(@client, path, name)
    end

  end
end
