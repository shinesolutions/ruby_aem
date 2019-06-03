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

require 'rexml/document'

module RubyAem
  # Response handlers for HTML payload.
  module Handlers
    include REXML
    # Parse authorizable ID from response body data.
    # This is used to get the authorizable ID of a newly created user/group.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.html_authorizable_id(response, response_spec, call_params)
      html = Document.new(response.body)
      authorizable_id = XPath.first(html, '//title/text()').to_s
      authorizable_id.slice! "Content created #{call_params[:path]}"
      call_params[:authorizable_id] = authorizable_id.sub(%r{^/}, '')

      message = response_spec['message'] % call_params

      RubyAem::Result.new(message, response)
    end

    # Parse error message from response body data.
    # This is to handle AEM hotfix, service pack, and feature pack package
    # installation which might cause AEM to respond with error 500 but it's
    # still processing behind the scene.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.html_package_service_allow_error(response, response_spec, call_params)
      html = Document.new(response.body)
      title = XPath.first(html, '//title/text()').to_s
      desc = XPath.first(html, '//p/text()').to_s
      reason = XPath.first(html, '//pre/text()').to_s

      call_params[:title] = title
      call_params[:desc] = desc
      call_params[:reason] = reason

      message = response_spec['message'] % call_params

      RubyAem::Result.new(message, response)
    end

    # Check response body for indicator of change password failure.
    # If response body is empty, that indicates that there's an error due to inexisting user.
    # Successful action produces a HTML page as response body.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def self.html_change_password(response, response_spec, call_params)
      if response.body.to_s.empty?
        message = 'Failed to change password: Response body is empty, user likely does not exist.'
        result = RubyAem::Result.new(message, response)
        raise RubyAem::Error.new(message, result)
      end

      html = Document.new(response.body)
      user = XPath.first(html, '//body/div/table/tr/td/b/text()').to_s
      desc = XPath.first(html, '//body/div/table/tr/td/font/text()').to_s

      if desc == 'Password successfully changed.'
        call_params[:user] = user
        message = response_spec['message'] % call_params
        RubyAem::Result.new(message, response)
      else
        message = desc
        result = RubyAem::Result.new(message, response)
        raise RubyAem::Error.new(message, result)
      end
    end
  end
end
