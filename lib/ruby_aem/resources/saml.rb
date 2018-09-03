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

module RubyAem
  module Resources
    # AEM class contains API calls related to managing SAML.
    class Saml
      # Initialise Saml.
      #
      # @param client RubyAem::Client
      # @return new RubyAem::Resources::Saml instance
      def initialize(client)
        @client = client
        @call_params = {}
      end

      # Create SAML configuration
      #
      # @param truststore_password Password for the Truststore
      # @return RubyAem::Result
      def create(params)
        @call_params = params
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete SAML configuration
      #
      # @return RubyAem::Result
      def delete
        @call_params[:apply] = true
        @call_params[:delete] = true

        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Get SAML configuration
      #
      # @param truststore_password Password for the Truststore
      # @return RubyAem::Result
      def get
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
