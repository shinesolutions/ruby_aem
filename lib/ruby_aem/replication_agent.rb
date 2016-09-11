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

module RubyAem
  # ReplicationAgent class contains API calls related to managing an AEM replication agent.
  class ReplicationAgent

    # Initialise a replication agent.
    #
    # @param client RubyAem::Client
    # @param run_mode AEM run mode: author or publish
    # @param name the replication agent's name, e.g. some-replication-agent
    # @return new RubyAem::ReplicationAgent instance
    def initialize(client, run_mode, name)
      @client = client
      @info = {
        run_mode: run_mode,
        name: name
      }
    end

    # Create or update a replication agent.
    #
    # @param title replication agent title
    # @param description replication agent description
    # @param dest_base_url base URL of the agent target destination, e.g. https://somepublisher:4503
    # @return RubyAem::Result
    def create_update(title, description, dest_base_url)
      @info[:title] = title
      @info[:description] = description
      @info[:dest_base_url] = dest_base_url
      @client.call(self.class, __callee__.to_s, @info)
    end

    # Delete the replication agent.
    #
    # @return RubyAem::Result
    def delete()
      @client.call(self.class, __callee__.to_s, @info)
    end

    # Check whether the replication agent exists or not.
    # If the replication agent  exists, this method returns a success result.
    # Otherwise it returns a failure result.
    #
    # @return RubyAem::Result
    def exists()
      @client.call(self.class, __callee__.to_s, @info)
    end

  end
end
