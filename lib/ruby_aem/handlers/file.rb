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
  # Response handlers for file payload.
  module Handlers

    # Handle downloaded file by copying from temporary location to file_path call param.
    # The downloaded file in temporary location will then be deleted.
    # data, status_code, and headers are all returned from RubyAem::Client call.
    #
    # @param response HTTP response containing status_code, body, and headers
    # @param response_spec response specification as configured in conf/spec.yaml
    # @param call_params API call parameters
    # @return RubyAem::Result
    def Handlers.file_download(response, response_spec, call_params)

      FileUtils.cp(response.body.path, "#{call_params[:file_path]}/#{call_params[:package_name]}-#{call_params[:package_version]}.zip")
      response.body.delete

      message = response_spec['message'] % call_params

      RubyAem::Result.new(message, response)
    end

  end
end
