# Copyright 2016-2018 Shine Solutions
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
    # AEM class contains API calls related to managing SSL via Granite.
    class Ssl
      # Initialise Ssl resource.
      #
      # @param client RubyAem::Client
      # @return new RubyAem::Resources::Ssl instance
      def initialize(client)
        @client = client
        @call_params = {
        }
      end

      # Disable SSL
      #
      # @return RubyAem::Result
      def disable
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Enable SSL
      #
      # @param opts hash of the following values:
      # - keystore_password: Authorizable Keystore password for system-user ssl-service. keystore will be created if it  doesn't exist.
      # - truststore_password: AEM Global Truststore password. Truststore will be created if it  doesn't exist.
      # - https_hostname: Hostname for enabling HTTPS listener matching the certificate's common name.
      # - https_port: Port to listen on for HTTPS requests.
      # - privatekey_file_path: Path to the HTTPS Private Key file.
      # - certificate_file_path:  Path to the HTTPS public certificate file.
      # @return RubyAem::Result
      def enable(opts = {
        keystore_password: nil,
        truststore_password: nil,
        https_hostname: nil,
        https_port: nil,
        certificate_file_path: nil,
        privatekey_file_path: nil
      })
        @call_params[:keystore_password] = opts[:keystore_password]
        @call_params[:keystore_passwordConfirm] = opts[:keystore_password]
        @call_params[:truststore_password] = opts[:truststore_password]
        @call_params[:truststore_passwordConfirm] = opts[:truststore_password]
        @call_params[:https_hostname] = opts[:https_hostname]
        @call_params[:https_port] = opts[:https_port]
        @call_params[:file_path_certificate] = opts[:certificate_file_path]
        @call_params[:file_path_private_key] = opts[:privatekey_file_path]

        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Get SSL Granite configuration
      #
      # @return RubyAem::Result
      def get
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
