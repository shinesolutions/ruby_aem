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
require 'uri'

module RubyAem
  module Resources
    # FlushAgent class contains API calls related to managing an AEM flush agent.
    class FlushAgent
      # Initialise a flush agent.
      #
      # @param client RubyAem::Client
      # @param run_mode AEM run mode: author or publish
      # @param name the flush agent's name, e.g. some-flush-agent
      # @return new RubyAem::Resources::FlushAgent instance
      def initialize(client, run_mode, name)
        @client = client
        @call_params = {
          run_mode: run_mode,
          name: name
        }
      end

      # Create or update a flush agent.
      #
      # @param title flush agent title
      # @param description flush agent description
      # @param dest_base_url base URL of the agent target destination, e.g. http://somedispatcher:8080
      # @param opts optional parameters:
      # - enabled: default is true
      # - flush_serialization_type: default is flush
      # - retry_delay: in milliseconds, default is 30_000
      # - agent_user_id: default is nil
      # - log_level: error, info, debug, default is error
      # - reverse_replication: default is false
      # - ssl: Default, Relaxed, Client Auth, default is nil
      # - https_expired: default is false
      # - specific: default is true
      # - modified: default is false
      # - distribute: default is false
      # - on_off_time: default is false
      # - receive: default is false
      # - no_status_update: default is true
      # - no_versioning: default is true
      # @return RubyAem::Result
      def create_update(
        title,
        description,
        dest_base_url,
        opts = {
          enabled: true,
          serialization_type: 'flush',
          retry_delay: 30_000
          agent_user_id: nil,
          log_level: 'error',
          reverse_replication: false,
          ssl: nil,
          http_expired: false,
          specific: true,
          modified: false,
          distribute: false,
          on_off_time: false,
          receive: false,
          no_status_update: true,
          no_versioning: true
        }
      )
        @call_params[:title] = title
        @call_params[:description] = description
        @call_params[:dest_base_url] = dest_base_url

        uri = URI.parse(dest_base_url)
        @call_params[:ssl] = uri.scheme == 'https' ? 'relaxed' : ''

        @call_params = @call_params.merge(opts)
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete the flush agent.
      #
      # @return RubyAem::Result
      def delete
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check whether the flush agent exists or not.
      # If the flush agent  exists, this method returns a true result data,
      # false otherwise.
      #
      # @return RubyAem::Result
      def exists
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
