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

require 'typhoeus'
require 'yaml'

module RubyAem
  #  AEM resources
  module Resources
    # AEM class contains API calls related to managing the AEM instance itself.
    class AemConfigMgr
      # Initialise an AEM instance.
      #
      # @param client RubyAem::Client
      # @return new RubyAem::Resources::Aem instance
      def initialize(client)
        @client = client
        @call_params = {
        }
      end
      # Connect to AEM /system/console/configMgr to collect
      # all configuration nodes
      #
      # @return RubyAem::Result
      def get_configmgr
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
