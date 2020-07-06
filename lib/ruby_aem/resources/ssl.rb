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
      # - certificate_file_path:  Path to the HTTPS public certificate file.
      # - privatekey_file_path: Path to the HTTPS Private Key file.
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

      # Check if SSL is enabled via Granite
      #
      # @return RubyAem::Result
      def is_enabled
        get_ssl = get

        response = get_ssl.response
        ssl_properties = response.body.properties
        ssl_enabled = ssl_properties.com_adobe_granite_jetty_ssl_port.is_set
        ssl_port = ssl_properties.com_adobe_granite_jetty_ssl_port.value

        message = if ssl_enabled.eql?(true)
                    "HTTPS has been configured on port #{ssl_port}"
                  else
                    'HTTPS is not configured'
                  end

        result = RubyAem::Result.new(message, response)
        result.data = ssl_enabled

        result
      end

      # Enable SSL via granite and wait until SSL was enabled
      #
      # @param opts hash of the following values:
      # - keystore_password: Authorizable Keystore password for system-user ssl-service. keystore will be created if it  doesn't exist.
      # - truststore_password: AEM Global Truststore password. Truststore will be created if it  doesn't exist.
      # - https_hostname: Hostname for enabling HTTPS listener matching the certificate's common name.
      # - https_port: Port to listen on for HTTPS requests.
      # - certificate_file_path:  Path to the HTTPS public certificate file.
      # - privatekey_file_path: Path to the HTTPS Private Key file.
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_tries, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def enable_wait_until_ready(
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

        # The AEM Granite API to enable SSl is unstable and in some cases it response with response code 0.
        # This is because the HTTP service is getting restarted during the process of enabling SSL via Granite.
        # To not end with an error we have to rescue this behaviour and verify afterwards if SSL was enabled.
        begin
          result = enable(**opts)
        rescue RubyAem::Error => e
          raise StandardError.new(result) unless e.result.response.status_code.zero?

          with_retries(max_tries: opts[:_retries][:max_tries], base_sleep_seconds: opts[:_retries][:base_sleep_seconds], max_sleep_seconds: opts[:_retries][:max_sleep_seconds]) { |retries_count|
            result = is_enabled
            message = 'SSL could not be configured or connection timeout please try again.'
            puts format('SSL Enable check #%<retries_count>d: %<check_result_data>s - %<check_result_message>s', retries_count: retries_count, check_result_data: result.data, check_result_message: result.message)
            raise StandardError.new(message) if result.data == false
          }
        end
        result
      end
    end
  end
end
