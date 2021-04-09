# Copyright 2016-2021 Shine Solutions Group
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
  # Result class represents the result of a client call.
  # It contains the following attributes:
  # - message: a message string containing the description of the result
  # - response: a RubyAem::Response response from AEM
  # - data: the data payload, which can be of any type depending on the API call
  # e.g. is_* and exists method provide result with boolean data.
  # Some API calls result doesn't contain any data.
  class Result
    attr_accessor :message
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
