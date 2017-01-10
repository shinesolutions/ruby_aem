=begin
Copyright 2016 Shine Solutions

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

require 'retries'

module RubyAem
  module Resources
    # AEM class contains API calls related to managing the AEM instance itself.
    class Aem

      # Initialise an AEM instance.
      #
      # @param client RubyAem::Client
      # @return new RubyAem::Resources::Aem instance
      def initialize(client)
        @client = client
        @call_params = {
        }
      end

      # Retrieve AEM login page.
      #
      # @return RubyAem::Result
      def get_login_page()
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Retrieve AEM login page with retries until it is successful.
      # This is handy for waiting for AEM to start or restart Jetty.
      #
      # @return RubyAem::Result
      def get_login_page_wait_until_ready()
        result = nil
        with_retries(:max_tries => 30, :base_sleep_seconds => 2, :max_sleep_seconds => 2) { |retries_count|
          begin
            result = get_login_page()
            puts 'Retrieve login page attempt #%d: %s' % [retries_count, result.message]
          rescue RubyAem::Error => err
            raise StandardError.new(result.message)
          end
        }
        result
      end

    end
  end
end
