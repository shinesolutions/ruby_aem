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
  # Result represents the result of a client call.
  #
  # It has 3 statuses: success, warning, and failure.
  # A success indicates that the client call was completed successfully.
  # A failure indicates that the client call was completed but it failed with error.
  # A warning indicates that the client call was completed but with warnings.
  #
  # Result message is stored in message attribute.
  #
  # Some client calls respond with data payload, which is stored in data attribute.
  class Result

    attr_reader :message
    attr_reader :response
    attr_accessor :data

    # Initialise a result.
    #
    # @param message result message
    # @param response HTTP response
    # @return new RubyAem::Result instance
    def initialize(message, response)
      @message = message
      @response = response
    end

  end
end
