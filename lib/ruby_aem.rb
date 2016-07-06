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
  class Aem

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

    def bundle(name)
      RubyAem::Bundle.new(@client, name)
    end

    def path(name)
      RubyAem::Path.new(@client, name)
    end

    def config_property(name, type, value)
      RubyAem::ConfigProperty.new(@client, name, type, value)
    end

    def flush_agent(name, run_mode)
      RubyAem::FlushAgent.new(@client, name, run_mode)
    end

    def group(path, name)
      RubyAem::Group.new(@client, path, name)
    end

    def node(path, name)
      RubyAem::Node.new(@client, path, name)
    end

    def package(group_name, package_name, package_version)
      RubyAem::Package.new(@client, group_name, package_name, package_version)
    end

    def replication_agent(name, run_mode)
      RubyAem::ReplicationAgent.new(@client, name, run_mode)
    end

    def repository
      RubyAem::Repository.new(@client)
    end

    def user(path, name)
      RubyAem::User.new(@client, path, name)
    end

  end
end
