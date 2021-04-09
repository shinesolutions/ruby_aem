# Copyright 2016-2018-2021 Shine Solutions Group
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
require 'ruby_aem/resources/truststore'

module RubyAem
  module Resources
    # AEM class contains API calls related to managing a certificate within AEM Truststore.
    # Since there is only 0 or 1 AEM Truststore with a global scope, a certificate
    # is by default associated to that global AEM Truststore.
    class Certificate
      # Initialise certificate.
      # Certificate resource uses serial number as identifier because AEM API endpoint
      # for importing a certificate does not allow the ability to specify an alias,
      # hence alias is assigned randomly by AEM, and this force us to use serial
      # number as the identifier because serial number is immutable on the certificate.
      # This is obviously not ideal, but we have to do it due to AEM API limitations.
      #
      # @param client RubyAem::Client
      # @param serial_number the certificate's serial number
      # @return new RubyAem::Resources::Certificate instance
      def initialize(
        client,
        serial_number
      )
        @client = client
        @truststore = RubyAem::Resources::Truststore.new(client)
        @serial_number = serial_number
        @call_params = {
          serial_number: serial_number
        }
        @cert_alias = _get_alias
      end

      # Create is an alias to import.
      # Create is needed to satisfy Puppet resource `ensure`.
      #
      # @param file_path local file path to certificate file
      # @return RubyAem::Result
      def create(file_path)
        import(file_path)
      end

      # Import a certificate file into AEM Truststore.
      #
      # @param file_path local file path to certificate file
      # @return RubyAem::Result
      def import(file_path)
        @call_params[:file_path] = file_path
        result = @client.call(self.class, __callee__.to_s, @call_params)
        @cert_alias = _get_alias
        result
      end

      # Export a certificate file from AEM Truststore.
      #
      # @param truststore_password Password for AEM Truststore
      # @return RubyAem::Result
      def export(truststore_password)
        temp_file = Tempfile.new.path
        @truststore.download(temp_file)

        truststore_raw = File.read temp_file
        truststore = OpenSSL::PKCS12.new(truststore_raw, truststore_password)

        certificate = nil
        truststore.ca_certs.each { |ca_cert|
          certificate = ca_cert if ca_cert.serial.to_s == @serial_number.to_s
        }
        result = RubyAem::Result.new('Certificate exported', nil)
        result.data = certificate
        result
      end

      # Delete a specific certificate from AEM Truststore by alias name or serial number.
      #
      # @return RubyAem::Result
      def delete
        result = exists
        raise RubyAem::Error.new('Certificate not found', result) if result.data == false

        @call_params[:cert_alias] = @cert_alias
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check if the certificate exists in AEM truststore.
      #
      # @return RubyAem::Result
      def exists
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      def _get_alias
        truststore_info = @truststore.info.data
        cert_alias = nil
        truststore_info.aliases.each { |certificate_alias|
          cert_alias = certificate_alias._alias.to_s if certificate_alias.serial_number.to_s == @serial_number.to_s
        }
        cert_alias
      end

      # Import a certificate file into AEM Truststore and wait until the certificate is imported.
      #
      # @param file_path local file path to certificate file
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def import_wait_until_ready(
        file_path,
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

        result = import(file_path)

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
