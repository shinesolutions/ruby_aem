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

module RubyAem
  module Resources
    # ReplicationAgent class contains API calls related to managing an AEM replication agent.
    class ReplicationAgent
      # Initialise a replication agent.
      #
      # @param client RubyAem::Client
      # @param run_mode AEM run mode: author or publish
      # @param name the replication agent's name, e.g. some-replication-agent
      # @return new RubyAem::Resources::ReplicationAgent instance
      def initialize(client, run_mode, name)
        @client = client
        @call_params = {
          run_mode: run_mode,
          name: name
        }
      end

      # Create or update a replication agent.
      #
      # @param title replication agent title
      # @param description replication agent description
      # @param dest_base_url base URL of the agent target destination, e.g. https://somepublisher:4503
      # @param opts optional parameters:
      # - transport_user: username for transport user, default is admin
      # - transport_password: password for transport user, default is admin
      # - log_level: error, info, debug, default is error
      # - retry_delay: in milliseconds, default is 30_000
      # - serialization_type: default is durbo
      # - user_id: default is nil
      # - enabled: default is true
      # - ssl: default is nil
      # - http_expired: default is nil
      # @return RubyAem::Result
      def create_update(
        title,
        description,
        dest_base_url,
        opts = {
          transport_user: 'admin',
          transport_password: 'admin',
          log_level: 'error',
          retry_delay: 30_000
          serialization_type: 'durbo',
          user_id: nil,
          enabled: true,
          ssl: nil,
          http_expired: nil
        }
      )
        @call_params[:title] = title
        @call_params[:description] = description
        @call_params[:dest_base_url] = dest_base_url

        @call_params = @call_params.merge(opts)
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Delete the replication agent.
      #
      # @return RubyAem::Result
      def delete
        @client.call(self.class, __callee__.to_s, @call_params)
      end

      # Check whether the replication agent exists or not.
      # If the replication agent  exists, this method returns a true result data,
      # false otherwise.
      #
      # @return RubyAem::Result
      def exists
        @client.call(self.class, __callee__.to_s, @call_params)
      end
    end
  end
end
