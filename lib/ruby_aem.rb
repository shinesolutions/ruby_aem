require 'bundle'
require 'client'
require 'config_property'
require 'path'
require 'repository'
require 'swagger_aem'
require 'yaml'

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

    @client = Client.new(apis, spec)
  end

  def bundle(name)
    Bundle.new(@client, name)
  end

  def path(name)
    Path.new(@client, name)
  end

  def config_property(name, type, value)
    ConfigProperty.new(@client, name, type, value)
  end

  def repository
    Repository.new(@client)
  end

end
