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
  # Response handlers for XML payload.
  module Handlers

    # Handle package list XML by removing non-packages data.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param info additional information
    # @return RubyAem::Result
    def Handlers.xml_package_list(response, response_spec, info)

      xml = Nokogiri::XML(response.body)

      status_code = xml.xpath('//crx/response/status/@code').to_s
      status_text = xml.xpath('//crx/response/status/text()').to_s

      if status_code == '200' && status_text == 'ok'
        message = response_spec['message'] % info
        result = RubyAem::Result.new(message, response)
        result.data = xml.xpath('//crx/response/data/packages')
      else
        result = RubyAem::Result.new("Unable to retrieve package list, getting status code #{status_code} and status text #{status_text}", response)
      end

      result
    end

  end
end
