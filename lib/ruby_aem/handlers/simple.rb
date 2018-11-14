# Copyright 2016-2017 Shine Solutions
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

require 'ruby_aem/error'
require 'ruby_aem/result'

module RubyAem
  # Response handlers for no payload.
  module Handlers
    # Simple handler by returning result that contains status and message as
    # configured in conf/spec.yaml AS-IS.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.simple(response, response_spec, call_params)
      message = response_spec['message'] % call_params
      RubyAem::Result.new(message, response)
    end

    # Simple handler with boolean true result data.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.simple_true(response, response_spec, call_params)
      result = Handlers.simple(response, response_spec, call_params)
      result.data = true
      result
    end

    # Simple handler with boolean false result data.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.simple_false(response, response_spec, call_params)
      result = Handlers.simple(response, response_spec, call_params)
      result.data = false
      result
    end

    # Simple handler with nil result data.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.simple_nil(response, response_spec, call_params)
      result = Handlers.simple(response, response_spec, call_params)
      result.data = nil
      result
    end

    # Simple handler with raised error.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.simple_error(response, response_spec, call_params)
      result = Handlers.simple(response, response_spec, call_params)
      raise RubyAem::Error.new(result.message, result)
    end

    # Simple handler with response body as result data.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.simple_body(response, response_spec, call_params)
      result = Handlers.simple(response, response_spec, call_params)
      result.data = response.body
      result
    end
  end
end
