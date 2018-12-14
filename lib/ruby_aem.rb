# Copyright 2016-2019 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'ruby_aem/client'
require 'ruby_aem/resources/aem'
require 'ruby_aem/resources/authorizable_keystore'
require 'ruby_aem/resources/bundle'
require 'ruby_aem/resources/certificate'
require 'ruby_aem/resources/certificate_chain'
require 'ruby_aem/resources/config_property'
require 'ruby_aem/resources/flush_agent'
require 'ruby_aem/resources/group'
require 'ruby_aem/resources/node'
require 'ruby_aem/resources/package'
require 'ruby_aem/resources/path'
require 'ruby_aem/resources/replication_agent'
require 'ruby_aem/resources/outbox_replication_agent'
require 'ruby_aem/resources/reverse_replication_agent'
require 'ruby_aem/resources/saml'
require 'ruby_aem/resources/repository'
require 'ruby_aem/resources/truststore'
require 'ruby_aem/resources/user'
require 'swagger_aem'
require 'yaml'

module RubyAem
  # Aem class represents an AEM client instance.
  class Aem
    # Initialise a Ruby AEM instance.
    #
    # @param conf configuration hash of the following configuration values:
    # - username: username used to authenticate to AEM instance, default: 'admin'
    # - password: password used to authenticate to AEM instance, default: 'admin'
    # - protocol: AEM instance protocol (http or https), default: 'http'
    # - host: AEM instance host name, default: 'localhost'
    # - port: AEM instance port, default: 4502
    # - timeout: connection timeout in seconds, default: 300 seconds
    # - debug: if true, then additional debug messages will be included, default: false
    # @return new RubyAem::Aem instance
    def initialize(conf = {})
      sanitise_conf(conf)

      SwaggerAemClient.configure { |swagger_conf|
        [
          swagger_conf.scheme = conf[:protocol],
          swagger_conf.host = "#{conf[:host]}:#{conf[:port]}",
          swagger_conf.username = conf[:username],
          swagger_conf.password = conf[:password],
          swagger_conf.timeout = conf[:timeout],
          swagger_conf.debugging = conf[:debug],
          swagger_conf.verify_ssl = conf[:verify_ssl],
          swagger_conf.verify_ssl_host = conf[:verify_ssl],
          swagger_conf.params_encoding = :multi
        ]
      }

      apis = {
        console: SwaggerAemClient::ConsoleApi.new,
        custom: SwaggerAemClient::CustomApi.new,
        cq: SwaggerAemClient::CqApi.new,
        crx: SwaggerAemClient::CrxApi.new,
        sling: SwaggerAemClient::SlingApi.new
      }

      spec = YAML.load_file(File.expand_path('../../conf/spec.yaml', __FILE__))

      @client = RubyAem::Client.new(apis, spec)
    end

    # Set default configuration values and handle numeric/boolean String values
    def sanitise_conf(conf)
      conf[:username] ||= 'admin'
      conf[:password] ||= 'admin'
      conf[:protocol] ||= 'http'
      conf[:host] ||= 'localhost'
      conf[:port] ||= 4502
      conf[:timeout] ||= 300
      # handle custom configuration value being passed as a String
      # e.g. when the values are passed via environment variables
      conf[:port] = conf[:port].to_i
      conf[:timeout] = conf[:timeout].to_i
      conf[:verify_ssl] = conf[:verify_ssl] == 'true' if conf[:verify_ssl].is_a? String
      conf[:debug] = conf[:debug] == 'true' if conf[:debug].is_a? String
    end

    # Create an AEM instance.
    #
    # @return new RubyAem::Resources::Aem instance
    def aem
      RubyAem::Resources::Aem.new(@client)
    end

    # Create a bundle instance.
    #
    # @param name the bundle's name, e.g. com.adobe.cq.social.cq-social-forum
    # @return new RubyAem::Resources::Bundle instance
    def bundle(name)
      RubyAem::Resources::Bundle.new(@client, name)
    end

    # Create a certificate instance.
    #
    # @param serial_number the certificate's serial number
    # @return new RubyAem::Resources::Certificate instance
    def certificate(serial_number)
      RubyAem::Resources::Certificate.new(@client, serial_number)
    end

    # # Create a certificate chain instance.
    # #
    # @param private_key_alias Alias of the private key associated to this certificate chain
    # @param keystore_intermediate_path AEM User home path
    # @param keystore_authorizable_id AEM User id
    # # @return new RubyAem::Resources::CertificateChain instance
    def certificate_chain(private_key_alias, keystore_intermediate_path, keystore_authorizable_id)
      RubyAem::Resources::CertificateChain.new(@client, private_key_alias, keystore_intermediate_path, keystore_authorizable_id)
    end

    # Create a config property instance.
    #
    # @param name the property's name
    # @param type the property's type, e.g. Boolean
    # @param value the property's value, e.g. true
    # @return new RubyAem::Resources::ConfigProperty instance
    def config_property(name, type, value)
      RubyAem::Resources::ConfigProperty.new(@client, name, type, value)
    end

    # Create a flush agent instance.
    #
    # @param run_mode AEM run mode: author or publish
    # @param name the flush agent's name, e.g. some-flush-agent
    # @return new RubyAem::Resources::FlushAgent instance
    def flush_agent(run_mode, name)
      RubyAem::Resources::FlushAgent.new(@client, run_mode, name)
    end

    # Create a group instance.
    #
    # @param path the path to group node, e.g. /home/groups/s/
    # @param name the name of the AEM group, e.g. somegroup
    # @return new RubyAem::Resources::Group instance
    def group(path, name)
      RubyAem::Resources::Group.new(@client, path, name)
    end

    # Create a Keystore instance for given authorizable id.
    #
    # @return new RubyAem::Resources::AuhtorizableKeystore instance
    def authorizable_keystore(intermediate_path, authorizable_id)
      RubyAem::Resources::AuthorizableKeystore.new(@client, intermediate_path, authorizable_id)
    end

    # Create a node instance.
    #
    # @param path the path to the node, e.g. /apps/system/
    # @param name the node name, e.g. somenode
    # @return new RubyAem::Resources::Node instance
    def node(path, name)
      RubyAem::Resources::Node.new(@client, path, name)
    end

    # Create a package instance.
    #
    # @param group_name the group name of the package, e.g. somepackagegroup
    # @param package_name the name of the package, e.g. somepackage
    # @param package_version the version of the package, e.g. 1.2.3
    # @return new RubyAem::Resources::Package instance
    def package(group_name, package_name, package_version)
      RubyAem::Resources::Package.new(@client, group_name, package_name, package_version)
    end

    # Create a path instance.
    #
    # @param name the name of the path, e.g. /etc/designs
    # @return new RubyAem::Resources::Path instance
    def path(name)
      RubyAem::Resources::Path.new(@client, name)
    end

    # Create a replication agent instance.
    #
    # @param run_mode AEM run mode: author or publish
    # @param name the replication agent's name, e.g. some-replication-agent
    # @return new RubyAem::Resources::ReplicationAgent instance
    def replication_agent(run_mode, name)
      RubyAem::Resources::ReplicationAgent.new(@client, run_mode, name)
    end

    # Create an outbox replication agent instance.
    #
    # @param run_mode AEM run mode: author or publish
    # @param name the outbox replication agent's name, e.g. some-outbox-replication-agent
    # @return new RubyAem::Resources::OutboxReplicationAgent instance
    def outbox_replication_agent(run_mode, name)
      RubyAem::Resources::OutboxReplicationAgent.new(@client, run_mode, name)
    end

    # Create a reverse replication agent instance.
    #
    # @param run_mode AEM run mode: author or publish
    # @param name the reverse replication agent's name, e.g. some-reverse-replication-agent
    # @return new RubyAem::Resources::ReverseReplicationAgent instance
    def reverse_replication_agent(run_mode, name)
      RubyAem::Resources::ReverseReplicationAgent.new(@client, run_mode, name)
    end

    # Create a repository instance.
    #
    # @return new RubyAem::Resources::Repository instance
    def repository
      RubyAem::Resources::Repository.new(@client)
    end

    # Create a Saml instance.
    #
    # @return new RubyAem::Resources::Saml instance
    def saml
      RubyAem::Resources::Saml.new(@client)
    end

    # Create a Truststore instance.
    #
    # @return new RubyAem::Resources::Truststore instance
    def truststore
      RubyAem::Resources::Truststore.new(@client)
    end

    # Create a user instance.
    #
    # @param path the path to user node, e.g. /home/users/s/
    # @param name the username of the AEM user, e.g. someuser, admin, johncitizen
    # @return new RubyAem::Resources::User instance
    def user(path, name)
      RubyAem::Resources::User.new(@client, path, name)
    end
  end
end
