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
      # @param opts optional parameters, parameter names can be retrieved from
      #   AEM OSGI config page for `com.adobe.granite.auth.saml.SamlAuthenticationHandler.config`
      #   Alternatively, they can also be retrieved from Swagger AEM specification
      #   at https://github.com/shinesolutions/swagger-aem/blob/master/conf/api.yml
      #   on operation ID `postConfigAdobeGraniteSamlAuthenticationHandler`
      #   Some parameters explanation can be found on https://helpx.adobe.com/experience-manager/6-3/sites/administering/using/saml-2-0-authenticationhandler.html
      # @return RubyAem::Result
      def create(opts)
        @call_params = @call_params.merge(opts)
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
      # @return RubyAem::Result
      def get
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
