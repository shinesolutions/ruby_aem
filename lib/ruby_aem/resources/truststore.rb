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

require 'openssl'
require 'retries'
require 'tempfile'
require 'ruby_aem/error'

module RubyAem
  module Resources
    # AEM class contains API calls related to managing the AEM Truststore.
    class Truststore
      # Initialise Truststore resource.
      #
      # @param client RubyAem::Client
      # @return new RubyAem::Resources::Truststore instance
      def initialize(client)
        @client = client
        @call_params = {}
      end

      # Create AEM Truststore.
      #
      # @param password Password for AEM Truststore
      # @return RubyAem::Result
      def create(password)
        @call_params[:password] = password
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Read the content of Truststore file on filesystem
      # and convert it to PKCS12 Truststore object.
      #
      # @param file_path path to Truststore file
      def read(file_path, password)
        truststore_raw = File.read file_path
        OpenSSL::PKCS12.new(truststore_raw, password)
      end

      # Download the AEM Truststore to a specified directory.
      #
      # @param file_path the directory where the Truststore will be downloaded to
      # @return RubyAem::Result
      def download(
        file_path
      )
        @call_params[:file_path] = file_path
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Upload a truststore PKCS12 file.
      #
      # @param file_path local file path to truststore PKCS12 file
      # @param opts optional parameters:
      # - force: if true then AEM Truststore will be overwritten if already exists
      # @return RubyAem::Result
      def upload(
        file_path,
        opts = {
          force: true
        }
      )
        @call_params[:file_path] = file_path
        @call_params = @call_params.merge(opts)
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete AEM Truststore.
      #
      # @return RubyAem::Result
      def delete
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check if AEM Truststore exists.
      #
      # @return RubyAem::Result
      def exists
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM Truststore info.
      #
      # @return RubyAem::Result
      def info
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Upload AEM Truststore and wait until the certificate is uploaded.
      #
      # @param file_path local file path to truststore PKCS12 file
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def upload_wait_until_ready(
        file_path,
        opts = {
          force: true,
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

        result = upload(file_path, force: opts[:force])

        with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
          check_result = exists
          puts format('Upload check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: check_result.data, check_result_message: check_result.message)
          raise StandardError.new(check_result.message) if check_result.data == false
        }
        result
      end
    end
  end
end
