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

require 'nokogiri'

module RubyAem
  # Response handlers for HTML payload.
  module Handlers

    # Parse authorizable ID from response body data.
    # This is used to get the authorizable ID of a newly created user/group.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def Handlers.html_authorizable_id(response, response_spec, call_params)

      html = Nokogiri::HTML(response.body)
      authorizable_id = html.xpath('//title/text()').to_s
      authorizable_id.slice! "Content created #{call_params[:path]}"
      call_params[:authorizable_id] = authorizable_id.sub(/^\//, '')

      status = response_spec['status']
      message = response_spec['message'] % call_params

      RubyAem::Result.new(message, response)
    end

  end
end
