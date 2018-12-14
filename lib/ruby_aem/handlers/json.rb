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

require 'json'
require 'ruby_aem/error'

module RubyAem
  # Response handlers for JSON payload.
  module Handlers
    # Handle JSON response payload containing authorizable ID.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.json_authorizable_id(response, response_spec, call_params)
      json = JSON.parse(response.body)
      authorizable_id = nil
      if json['success'] == true && json['hits'].length == 1
        authorizable_id = json['hits'][0]['name']
        call_params[:authorizable_id] = authorizable_id
        message = response_spec['message'] % call_params
      else
        message = "User/Group #{call_params[:name]} authorizable ID not found"
      end

      result = RubyAem::Result.new(message, response)
      result.data = authorizable_id
      result
    end

    # Handle package JSON payload. Result status is determined directly by success field.
    # NOTE: _response_spec and _call_params are not used in the implementation
    # of this method, but they are needed for the handler signature.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param _response_spec response specification as configured in conf/spec.yaml
    # @param _call_params additional call_params information
    # @return RubyAem::Result
    def self.json_package_service(response, _response_spec, _call_params)
      json = JSON.parse(response.body)

      message = json['msg']
      result = RubyAem::Result.new(message, response)

      return result if json['success'] == true

      raise RubyAem::Error.new(message, result)
    end

    # Handle package filter JSON payload.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params additional call_params information
    # @return RubyAem::Result
    def self.json_package_filter(response, response_spec, call_params)
      json = JSON.parse(response.body)

      filter = []
      json.each_key do |key|
        filter.push(json[key]['root']) unless json[key]['root'].nil?
      end

      message = response_spec['message'] % call_params

      result = RubyAem::Result.new(message, response)
      result.data = filter
      result
    end

    # Handle AEM Health Check Servlet JSON payload.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params additional call_params information
    # @return RubyAem::Result
    def self.json_aem_health_check(response, response_spec, call_params)
      json = JSON.parse(response.body)

      message = response_spec['message'] % call_params

      result = RubyAem::Result.new(message, response)
      result.data = json['results']
      result
    end

    # Extract a list of agent names from getAgents JSON payload.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params additional call_params information
    # @return RubyAem::Result
    def self.json_agents(response, response_spec, call_params)
      json = JSON.parse(response.body)

      agent_names = []
      json.each_key do |key|
        agent_names.push(key) if (!key.start_with? 'jcr:') && (!key.start_with? 'rep:')
      end

      message = response_spec['message'] % call_params

      result = RubyAem::Result.new(message, response)
      result.data = agent_names
      result
    end

    # Truststore payload handler, checks for the existence of certificate within
    # AEM Truststore, identified by cert_alias call parameter.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.json_certificate_exists(response, response_spec, call_params)
      truststore_info = response.body

      result = Handlers.simple(response, response_spec, call_params)

      certificate_exists = false
      truststore_info.aliases.each { |certificate_alias|
        certificate_exists = true if certificate_alias.serial_number.to_s == call_params[:serial_number].to_s
      }
      if certificate_exists == false
        result.data = false
        result.message = 'Certificate not found'
      else
        result.data = true
        result.message = 'Certificate exists'
      end

      result
    end

    # Authorizable keystore payload handler, checks for the existence of certificate within
    # AEM Truststore, identified by cert_alias call parameter.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.json_certificate_chain_exists(response, response_spec, call_params)
      authorizable_keystore_info = response.body

      result = Handlers.simple(response, response_spec, call_params)

      certificate_chain_exists = false
      authorizable_keystore_info.aliases.each { |certificate_chain_alias|
        certificate_chain_exists = true if certificate_chain_alias._alias.to_s == call_params[:private_key_alias].to_s
      }
      if certificate_chain_exists == false
        result.data = false
        result.message = 'Certificate chain not found'
      else
        result.data = true
        result.message = 'Certificate chain exists'
      end

      result
    end

    # Truststore payload handler, checks for exists and aliases properties in
    # order to identify existence.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.json_truststore_exists(response, response_spec, call_params)
      truststore_info = response.body

      result = Handlers.simple(response, response_spec, call_params)

      if truststore_info.exists == false
        result.data = false
        result.message = 'Truststore not found'
      elsif truststore_info.aliases.is_a?(Array)
        result.data = true
      end

      result
    end

    # Authorizable keystore payload handler, checks for exists and aliases
    # properties in order to identify existence.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.json_authorizable_keystore_exists(response, response_spec, call_params)
      keystore_info = response.body

      result = Handlers.simple(response, response_spec, call_params)

      if keystore_info.exists == false
        result.data = false
        result.message = 'Authorizable keystore not found'
      elsif keystore_info.aliases.is_a?(Array)
        result.data = true
      end

      result
    end

    # Handle product info JSON payload. Result status is determined directly by success field.
    # NOTE: _response_spec and _call_params are not used in the implementation
    # of this method, but they are needed for the handler signature.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param _response_spec response specification as configured in conf/spec.yaml
    # @param _call_params additional call_params information
    # @return RubyAem::Result
    def self.json_product_info(response, _response_spec, _call_params)
      message = 'AEM Product informations found'
      result = RubyAem::Result.new(message, response)
      result.data = response.body

      result
    end
  end
end
