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

require 'openssl'
require 'retries'
require 'tempfile'
require 'ruby_aem/error'
require 'ruby_aem/resources/authorizable_keystore'

module RubyAem
  module Resources
    # AEM class contains API calls related to managing a certificate chain within AEM Authorizable Keystore.
    class CertificateChain
      # Initialise certificate chain
      #
      # @param client RubyAem::Client
      # @param private_key_alias Alias of the private key associated to this certificate chain
      # @param keystore_intermediate_path AEM User home path
      # @param keystore_authorizable_id AEM User id
      # @return new RubyAem::Resources::AuhtorizableKeystore instance
      def initialize(client, private_key_alias, keystore_intermediate_path, keystore_authorizable_id)
        @client = client
        @truststore = RubyAem::Resources::Truststore.new(client)
        @private_key_alias = private_key_alias
        @call_params = {
          private_key_alias: private_key_alias,
          keystore_intermediate_path: keystore_intermediate_path,
          keystore_authorizable_id: keystore_authorizable_id
        }
      end

      # Create is an alias to import.
      # Create is needed to satisfy Puppet resource `ensure`.
      #
      # @param certificate_chain_file_path file path to certificate chain file
      # @param private_key_file_path file path to private key associated to the certificate chain
      # @return RubyAem::Result
      def create(certificate_chain_file_path, private_key_file_path)
        import(certificate_chain_file_path, private_key_file_path)
      end

      # Import a certificate file into AEM Truststore.
      #
      # @param certificate_chain_file_path file path to certificate chain file
      # @param private_key_file_path file path to private key associated to the certificate chain
      # @return RubyAem::Result
      def import(certificate_chain_file_path, private_key_file_path)
        @call_params[:file_path_certificate] = certificate_chain_file_path
        @call_params[:file_path_private_key] = private_key_file_path
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete a specific certificate chain by its associated private key alias.
      #
      # @return RubyAem::Result
      def delete
        result = exists
        raise RubyAem::Error.new('Certificate chain not found', result) if result.data == false

        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check if certificate chain exists in the Authorizable Keystore.
      #
      # @return RubyAem::Result
      def exists
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Import a certificate file into AEM Truststore and wait until the certificate is imported.
      #
      # @param certificate_chain_file_path file path to certificate chain file
      # @param private_key_file_path file path to private key associated to the certificate chain
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def import_wait_until_ready(
        certificate_chain_file_path,
        private_key_file_path,
        opts = {
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        }
      )
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        # ensure integer retries setting (Puppet 3 passes numeric string)
        opts[:_retries][:max_tries] = opts[:_retries][:max_tries].to_i
        opts[:_retries][:base_sleep_seconds] = opts[:_retries][:base_sleep_seconds].to_i
        opts[:_retries][:max_sleep_seconds] = opts[:_retries][:max_sleep_seconds].to_i

        result = import(certificate_chain_file_path, private_key_file_path)

        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = exists
          puts format('Import check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: check_result.data, check_result_message: check_result.message)
          raise StandardError.new(check_result.message) if check_result.data == false
        }
        result
      end
    end
  end
end
