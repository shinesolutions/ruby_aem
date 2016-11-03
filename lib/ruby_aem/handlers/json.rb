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

require 'json'

module RubyAem
  # Response handlers for JSON payload.
  module Handlers

    # Handle JSON response payload containing authorizable ID.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param info additional information
    # @return RubyAem::Result
    def Handlers.json_authorizable_id(response, response_spec, info)

      json = JSON.parse(response.body)
      authorizable_id = nil
      if json['success'] == true && json['hits'].length == 1
        authorizable_id = json['hits'][0]['name']
        info[:authorizable_id] = authorizable_id
        message = response_spec['message'] % info
      else
        message = "User/Group #{info[:name]} authorizable ID not found"
      end

      status = response_spec['status']

      result = RubyAem::Result.new(message, response)
      result.data = authorizable_id
      result
    end

    # Handle package JSON payload. Result status is determined directly by success field.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param info additional information
    # @return RubyAem::Result
    def Handlers.json_package_service(response, response_spec, info)

      json = JSON.parse(response.body)

      status = json['success'] == true ? 'success' : 'failure'
      message = json['msg']

      RubyAem::Result.new(message, response)
    end

    # Handle package filter JSON payload.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param info additional information
    # @return RubyAem::Result
    def Handlers.json_package_filter(response, response_spec, info)

      json = JSON.parse(response.body)

      filter = []
      json.each do |key, value|
        if json[key]['root'] != nil
          filter.push(json[key]['root'])
        end
      end

      message = response_spec['message'] % info

      result = RubyAem::Result.new(message, response)
      result.data = filter
      result

    end

  end
end
