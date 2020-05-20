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
require 'ruby_aem/resources/truststore'

module RubyAem
  module Resources
    # AEM class contains API calls related to managing a certificate within AEM Truststore.
    # Since there is only 0 or 1 AEM Truststore with a global scope, a certificate
    # is by default associated to that global AEM Truststore.
    class Ssl
      # Initialise ssl.
      # @param client RubyAem::Client
      # @param keystore_password required password for key
      # @param truststore_password required password for key
      # @param https_hostname required hostname for ssl, if you run it locally you should use "localhost"
      # @param https_port is the port that ssl service will run
      # @param privatekey_file key file path
      # @param certificate_file certificate file path
      def initialize(client, keystore_password, truststore_password, https_hostname, https_port, privatekey_file, certificate_file)
        @client = client
        @call_params = {
          keystore_password: keystore_password,
          keystore_passwordConfirm: keystore_password,
          truststore_password: truststore_password,
          truststore_passwordConfirm: truststore_password,
          https_hostname: https_hostname,
          https_port: https_port,
          privatekey_file: privatekey_file,
          certificate_file: certificate_file,
        }
      end
      def create
        @client.call(self.class, __callee__.to_s, @call_params)

      end
    end
  end
end
