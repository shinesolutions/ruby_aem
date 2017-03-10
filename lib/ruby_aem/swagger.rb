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

module RubyAem
  # Swagger module contains logic related to swagger_aem.
  module Swagger

    # Convert ruby_aem spec's operation (consistent with Swagger spec's operationId)
    # into swagger_aem's generated method name.
    #
    # @param operation operation ID
    # @return swagger_aem method name
    def Swagger.operation_to_method(operation)
      operation.gsub(/[A-Z]/) { |char|
        '_' + char.downcase
      }
    end

    # Convert ruby_aem spec's property name (by replacing dots with underscores)
    # into swagger_aem's generated parameter name.
    #
    # @param property property name
    # @return swagger_aem parameter name
    def Swagger.property_to_parameter(property)
      property.gsub(/\./, '_')
    end

    # Sanitise path value by removing leading and trailing slashes
    # swagger_aem accepts paths without those slashes.
    #
    # @param path path name
    # @return sanitised path name
    def Swagger.path(path)
      path.gsub(/^\//, '').gsub(/\/$/, '')
    end

    # Given a config node name, return the corresponding OSGI config name.
    # OSGI config name are available from AEM Web Console's Config Manager page.
    #
    # @param config_node_name the name of the node for a given config
    # @return config name
    def Swagger.config_node_name_to_config_name(config_node_name)
      case config_node_name
      when 'org.apache.felix.http'
        'Apache Felix Jetty Based HTTP Service'
      when 'org.apache.sling.servlets.get.DefaultGetServlet'
        'Apache Sling GET Servlet'
      when 'org.apache.sling.security.impl.ReferrerFilter'
        'Apache Sling Referrer Filter'
      when 'org.apache.sling.jcr.davex.impl.servlets.SlingDavExServlet'
        'Apache Sling DavEx Servlet'
      else
        nil
      end
    end

  end
end
