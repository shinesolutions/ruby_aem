require 'ruby_aem/bundle'
require 'ruby_aem/client'
require 'ruby_aem/config_property'
require 'ruby_aem/group'
require 'ruby_aem/node'
require 'ruby_aem/path'
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

    def group(path, name)
      RubyAem::Group.new(@client, path, name)
    end

    def node(path, name)
      RubyAem::Node.new(@client, path, name)
    end

    def repository
      RubyAem::Repository.new(@client)
    end

    def user(path, name)
      RubyAem::User.new(@client, path, name)
    end

  end
end
