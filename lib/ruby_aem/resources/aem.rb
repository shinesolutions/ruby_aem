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
require 'ruby_aem/error'

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
      # @param opts optional parameters:
      # - _retries: retries library's options (http://www.rubydoc.info/gems/retries/0.0.5#Usage), restricted to max_trie, base_sleep_seconds, max_sleep_seconds
      # @return RubyAem::Result
      def get_login_page_wait_until_ready(
        opts = {
          _retries: {
            max_tries: 30,
            base_sleep_seconds: 2,
            max_sleep_seconds: 2
          }
        })
        opts[:_retries] ||= {}
        opts[:_retries][:max_tries] ||= 30
        opts[:_retries][:base_sleep_seconds] ||= 2
        opts[:_retries][:max_sleep_seconds] ||= 2

        result = nil
        with_retries(:max_tries => opts[:_retries][:max_tries], :base_sleep_seconds => opts[:_retries][:base_sleep_seconds], :max_sleep_seconds => opts[:_retries][:max_sleep_seconds]) { |retries_count|
          begin
            result = get_login_page()
            if result.response.body !~ /QUICKSTART_HOMEPAGE/
              puts 'Retrieve login page attempt #%d: %s but not ready yet' % [retries_count, result.message]
              raise StandardError.new(result.message)
            else
              puts 'Retrieve login page attempt #%d: %s and ready' % [retries_count, result.message]
            end
          rescue RubyAem::Error => err
            puts 'Retrieve login page attempt #%d: %s' % [retries_count, err.message]
            raise StandardError.new(err.message)
          end
        }
        result
      end

    end
  end
end
