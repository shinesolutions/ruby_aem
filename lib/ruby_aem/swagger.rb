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

module RubyAem
  # Swagger module contains logic related to swagger_aem.
  module Swagger
    # Convert ruby_aem spec's operation (consistent with Swagger spec's operationId)
    # into swagger_aem's generated method name.
    #
    # @param operation operation ID
    # @return swagger_aem method name
    def self.operation_to_method(operation)
      operation.gsub(/[A-Z]/) { |char|
        '_' + char.downcase
      }
    end

    # Generate compatible operation ID for swagger-aem-osgi
    #
    # @param config_node_id configuration node IP
    # @return Swagger compatible operation_id
    def gen_operation_id(config_node_id)
      # Clone config node id so we get a new object_id to alter with
      operation_id_cloned = config_node_id.clone

      # Operation Ids with more than 70 chars are not supported
      operation_id_raw = operation_id_cloned.slice(0...70)

      # Convert each first char after non alphabetical char to UPPERCASE
      # operation_id_uppercase_after_dots = operation_id_raw.gsub!(/(\W[a-zA-Z])/){ $1.upcase }
      operation_id_uppercase_after_dots = operation_id_raw.gsub!(/(\W[a-zA-Z])/) { Regexp.last_match(1).upcase }

      # Replace each special char with '.' if config_node_id_uppercase_after_dots is not nil
      operation_id_raw = operation_id_uppercase_after_dots.gsub(/\W/, '') unless operation_id_uppercase_after_dots.nil?

      # If config_node_id doesn't has any non alphabetical char we return the
      # operation_id_raw
      return operation_id_raw if operation_id_uppercase_after_dots.nil?

      # Convert first char to lower case
      # operation_id = operation_id_raw.gsub!(/(^.)/) { $1.downcase }
      operation_id = operation_id_raw.gsub!(/(^.)/) { Regexp.last_match(1).downcase }

      operation_id
    end

    # Convert ruby_aem spec's property name (by replacing dots with underscores)
    # into swagger_aem's generated parameter name.
    #
    # @param property property name
    # @return swagger_aem parameter name
    def self.property_to_parameter(property)
      if ['alias'].include? property
        "_#{property}"
      else
        property.tr('.', '_').tr('-', '_')
      end
    end

    # Sanitise path value by removing leading and trailing slashes
    # swagger_aem accepts paths without those slashes.
    #
    # @param path path name
    # @return sanitised path name
    def self.path(path)
      path.gsub(%r{^/}, '').gsub(%r{/$}, '')
    end
  end
end
